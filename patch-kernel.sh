#!/bin/sh

set -e
kdir="$1"

test -d "$kdir" || {
  echo "Usage: ${0##*/} <kernel_source_dir> [<extra_patches..>]" >&2
  echo " <extra_patches> without path are assumed to reside in aufs source directory" >&2
  exit 1
}

shift

: ${aufs_dir:=$(dirname "$0")}

for patch in aufs4-kbuild.patch aufs4-base.patch aufs4-mmap.patch aufs4-standalone.patch "$@";do
  case "$patch" in */*) ;; *) patch="$aufs_dir/$patch" ;; esac
  ( cd "$kdir" ; patch -p1 ) < "$patch"
done

kdir_abs="$(readlink -f "$kdir")"
( cd "$aufs_dir"; cp --parents -avt "$kdir_abs" "Documentation" "fs" "include/uapi/linux/aufs_type.h" )
