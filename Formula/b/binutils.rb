class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  compatibility_version 1

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "4d34689d19f2632b8575ca61e866568b44be203b22fc360d9866ba832fcf277a"
    sha256               arm64_sequoia: "b007ac9a89e3d86b0bdf067ab442ebfeb4057df6b570226bee36b9c53dc1ae1e"
    sha256               arm64_sonoma:  "d5258ef24196dd9da0dbfe8180fe59f01f6f8caab2af0ba5a8118a072486ba73"
    sha256               sonoma:        "87c99a3cfc8346de2c16bb0b54b2454b139ac27ba6364bdaf7d24697a3c14c94"
    sha256 cellar: :any, arm64_linux:   "b30d07e9d4ad52380816baa8abb96187e625c5b207f16be1e52e8c393d7a7bb1"
    sha256 cellar: :any, x86_64_linux:  "fbe5aefd73f5d4397166a067ab1ff7d6142f6c82c1ceb7c1fabdbe1b2fb9ef64"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "etc/ld.so.conf"

  link_overwrite "bin/dwp"

  def install
    args = %W[
      --disable-default-execstack
      --disable-nls
      --disable-werror
      --enable-64-bit-bfd
      --enable-default-hash-style=gnu
      --enable-deterministic-archives
      --enable-multilib
      --enable-plugins
      --enable-relro
      --enable-shared
      --enable-targets=all
      --infodir=#{info}
      --mandir=#{man}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
      --with-zstd
    ]

    system "./configure", *args, *std_configure_args
    system "make", "tooldir=#{prefix}"
    system "make", "tooldir=#{prefix}", "install"

    # libbfd and libopcodes shouldn't be dynamically linked by external binaries.
    # This modification is similar to the decision made by Arch Linux and Fedora.
    rm([lib/shared_library("libbfd"), lib/shared_library("libopcodes")])

    if OS.mac?
      bin.each_child do |f|
        bin.install_symlink f => "g#{f.basename}"
      end
    else
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")

      # Allow ld to find brew glibc. A broken symlink falls back to /etc/ld.so.conf
      (prefix/"etc").install_symlink etc/"ld.so.conf"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
    assert_predicate prefix/"etc/ld.so.conf", :symlink? if OS.linux?
  end
end