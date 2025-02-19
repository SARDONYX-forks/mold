#!/bin/bash
. $(dirname $0)/common.inc

cat <<EOF | $CC -o $t/a.o -fPIC -c -xc -
__attribute__((weak, visibility("hidden"))) void foo();
void bar() { foo(); }
EOF

$CC -B. -shared -o $t/b.so $t/a.o

readelf -W --dyn-syms $t/b.so > $t/log
not grep -w foo $t/log
grep -w bar $t/log
