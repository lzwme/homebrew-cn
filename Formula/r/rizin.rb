class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://ghfast.top/https://github.com/rizinorg/rizin/releases/download/v0.8.2/rizin-src-v0.8.2.tar.xz"
  sha256 "1630ca52bae86f2ff37eb220699fc82f951b5b18080edfa3f50dd36a526c2d95"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_tahoe:   "623c6e5ca6f9d24278c73a8b2139e30ae5eac16f939a2d4f81ff6e30dd4e77a9"
    sha256 arm64_sequoia: "700ecc118cb84d3f5bfb3a6f9849a489111a071e22bdb7c4f0cc3ad3f2300e5b"
    sha256 arm64_sonoma:  "abcee8b4f9fe0a5e4bb40a7f1e7417a452960f22b6a643663c22aa6c28bce09b"
    sha256 sonoma:        "1ae8492e9cd00a23944df4e0b430c6cf9652c2a7d781abbe878edd885f406d1d"
    sha256 arm64_linux:   "7e13ca87860a53034a1225e3798fce5fa94bed357fccf8fd544fb7d49659fb67"
    sha256 x86_64_linux:  "58b1252759962edffdfbc2b1f1ce5870cb59dd8371ffcedee41ca4d9fdf10078"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = %W[
      -Dpackager=#{tap.user}
      -Dpackager_version=#{pkg_version}
      -Duse_sys_capstone=enabled
      -Duse_sys_libzip_openssl=true
      -Duse_sys_libzip=enabled
      -Duse_sys_libzstd=enabled
      -Duse_sys_lz4=enabled
      -Duse_sys_lzma=enabled
      -Duse_sys_magic=enabled
      -Duse_sys_openssl=enabled
      -Duse_sys_pcre2=enabled
      -Duse_sys_xxhash=enabled
      -Duse_sys_zlib=enabled
      -Duse_sys_tree_sitter=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
      --wrap-mode=nodownload
    ]

    fallback = %w[rzgdb rzwinkd rzar rzqnx tree-sitter-c rzspp rizin-shell-parser rzheap]
    fallback << "ptrace-wrap" unless OS.mac?
    args << "--force-fallback-for=#{fallback.join(",")}"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/rizin/plugins").mkpath
  end

  def caveats
    <<~EOS
      Plugins, extras and bindings will installed at:
        #{HOMEBREW_PREFIX}/lib/rizin
    EOS
  end

  test do
    assert_match "rizin #{version}", shell_output("#{bin}/rizin -v")
    assert_match "2a00a0e3", shell_output("#{bin}/rz-asm -a arm -b 32 'mov r0, 42'")
    assert_match "push rax", shell_output("#{bin}/rz-asm -a x86 -b 64 -d 0x50")
  end
end