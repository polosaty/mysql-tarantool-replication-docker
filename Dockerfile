FROM ubuntu:18.04 as build

RUN apt update && apt install -y git make cmake gcc g++ libncurses5-dev


# cd /mysql_tarantool-replication/lib/libslave/include/boost_1_59_0/boost
# ln -s . boost
# /mysql-tarantool-replication/lib/libslave/field.h
# +include <vector>
# /mysql-tarantool-replication/lib/libslave# git diff
# diff --git a/field.h b/field.h
# index 246ba2f..be42523 100644
# --- a/field.h
# +++ b/field.h
# @@ -16,6 +16,7 @@
#  #define __SLAVE_FIELD_H_

#  #include <string>
# +#include <vector>
#  #include <boost/any.hpp>
#  #include "collate.h"

# diff --git a/mysql-src b/mysql-src
# --- a/mysql-src
# +++ b/mysql-src
# @@ -1 +1 @@
# -Subproject commit 23032807537d8dd8ee4ec1c4d40f0633cd4e12f9
# +Subproject commit 23032807537d8dd8ee4ec1c4d40f0633cd4e12f9-dirty

# git submodule status
#  ff89578737bf437c774a4763f6cccdb2570c0177 libslave (ff89578)
#  b1b5fef8334fff8ea78df7de0d4caf273438faa2 tarantool-c (1.0-87-gb1b5fef)
#  3d9ad75af7e8aff720d8c529b7d5480442d4591c yaml-cpp (release-0.5.3-46-g3d9ad75)

RUN git clone https://github.com/tarantool/mysql-tarantool-replication.git /mysql_tarantool-replication
# раскомментировать если перестанет собираться мастер
# RUN cd /mysql_tarantool-replication && git checkout 7cec0039500874f42ab12b13595fa2a14431d042
RUN cd /mysql_tarantool-replication \
    && git submodule update --init --recursive

ADD libslave.patch /mysql_tarantool-replication/libslave.patch

RUN cd /mysql_tarantool-replication \
    && cmake -DCMAKE_BUILD_TYPE=Release . && cmake --build . \
    || \
        echo "== workarounds ==" \
        && cd /mysql_tarantool-replication/lib/libslave/include/boost_1_59_0/boost \
        && ln -s . boost \
        && cd /mysql_tarantool-replication/lib/libslave \
        && git apply < /mysql_tarantool-replication/libslave.patch

RUN cd /mysql_tarantool-replication \
    && cmake --build .

FROM ubuntu:18.04
COPY --from=0 /mysql_tarantool-replication/replicatord .
