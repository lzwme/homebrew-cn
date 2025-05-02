class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https:rizin.re"
  url "https:github.comrizinorgrizinreleasesdownloadv0.8.0rizin-src-v0.8.0.tar.xz"
  sha256 "da9ac726109719289f908007d1802c6494a23c43cb9950ca42821d42aa5c7e37"
  license "LGPL-3.0-only"
  head "https:github.comrizinorgrizin.git", branch: "dev"

  bottle do
    sha256 arm64_sequoia: "c8150052cb5c41080ea6f0c027a36fdc72ef923c65a4d056cae93262d691a742"
    sha256 arm64_sonoma:  "a5f021f51912127affaf4ecf54f6d1b8451321a6f8588983d15c6c0f03138ae6"
    sha256 arm64_ventura: "cc98e4e166c5183f25dd96428f7902580a705e9e9a3230e8c56233e6790c5fcb"
    sha256 sonoma:        "a64131f4e26df6229621de49a12a67cc8a1dd38aa43a8c94b1d5ddaf60a20e77"
    sha256 ventura:       "910341269e8ac3bc62483c79b600b257a714b5bba8d192c7f412c040173c5c21"
    sha256 arm64_linux:   "9d97a0ca9d597a3e8abe963815acfe042926133ed24dfc25e12e7cf1456a3f6b"
    sha256 x86_64_linux:  "abda6579445c01dc9da7018358b66ecbe7102f3841b918c125f0449acb91d1b9"
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

  # Fix to use `rizin-grammar-c` unconditionally, should be removed in next release
  # PR Ref: https:github.comrizinorgrizinpull5103
  patch do
    url "https:github.comrizinorgrizincommite196efaefbd2aa47204185c6b280654d9d964723.patch?full_index=1"
    sha256 "0dfa2792793a7cafe35f08bf630dbfd943c05f7778c66f5054833d92d6475caa"
  end

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
    (HOMEBREW_PREFIX"librizinplugins").mkpath
  end

  def caveats
    <<~EOS
      Plugins, extras and bindings will installed at:
        #{HOMEBREW_PREFIX}librizin
    EOS
  end

  test do
    assert_match "rizin #{version}", shell_output("#{bin}rizin -v")
    assert_match "2a00a0e3", shell_output("#{bin}rz-asm -a arm -b 32 'mov r0, 42'")
    assert_match "push rax", shell_output("#{bin}rz-asm -a x86 -b 64 -d 0x50")
  end
end