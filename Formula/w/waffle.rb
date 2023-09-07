class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  license "BSD-2-Clause"
  revision 1
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  stable do
    url "https://waffle.freedesktop.org/files/release/waffle-1.7.2/waffle-1.7.2.tar.xz"
    sha256 "f676195cfea58cc75ef2441c5616b2f1d5565a7d371a6aa655aff3cc67c7c2c9"

    # https://gitlab.freedesktop.org/mesa/waffle/-/merge_requests/128
    patch do
      url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/bce1f755b129aff34c21236bfa3b915f08b7246f/waffle/meson-fix-macOS-typo.patch"
      sha256 "a072865ad22a4828e92b0e945d185feacd2596cd7d0e09828e5fb954e3b453d9"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "721f578546fef947d5988c423d62edbf5ca4df91bf23132edd0a3dba96e415f3"
    sha256 cellar: :any, arm64_monterey: "bd5edd13379bac6277403de70afc6a513ab780f0aaf19ee40c0e56487a1fb7b4"
    sha256 cellar: :any, arm64_big_sur:  "3fdbf3b04577f26ecc7b15bb75ccb973157a3aea16e76b604627c215e4b79fa4"
    sha256 cellar: :any, ventura:        "88d13319655ba24a51c7de5342d3e01a90ec5e74abd415f2d5a6ac5f5d601ff6"
    sha256 cellar: :any, monterey:       "9675280d92c77e188cf93c766040a4f713a9e387817183c3cc646dd581a876a4"
    sha256 cellar: :any, big_sur:        "cfda02466d84027d572e6c524bda6041d9f3e401f5ff8a7994cdffdaca0be1d8"
    sha256               x86_64_linux:   "ef964770f31d2fdae40b23efc0b3b1c1fffdfa8430eb125adf9a9d8c805f0bb1"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    # https://gitlab.freedesktop.org/mesa/waffle/-/issues/115
    # Fix: Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/netinet/ip.h:102:2:
    # error: unknown type name 'u_char'; did you mean 'char'?
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    args = %w[
      -Dbuild-examples=true
      -Dbuild-htmldocs=true
      -Dbuild-manpages=true
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "Makefile.example", "$(LDFLAGS) -o gl_basic gl_basic.c",
                "gl_basic.c $(LDFLAGS) -o gl_basic"
      inreplace "Makefile.example", "$(LDFLAGS) -o simple-x11-egl simple-x11-egl.c",
                "simple-x11-egl.c $(LDFLAGS) -o simple-x11-egl"
    end
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?
    system "make", "-f", "Makefile.example"
  end
end