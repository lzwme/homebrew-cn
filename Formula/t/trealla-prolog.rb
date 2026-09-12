class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.66.tar.gz"
  sha256 "605f24bfd19f5e48f2c5044d2b2780ccab3f3364ecdc4101a63d1844e8005ea6"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "fe12482f58a1caadd4fe550b8e764e3b128f483a8cea148a130d275f27651779"
    sha256 arm64_tahoe:       "7a55339c2135c3b69acc2ec0703907d2a1c906409a33b10ad680252e4008a42b"
    sha256 arm64_sequoia:     "9cf2eb814bc16c0c297218437548c04a19ba9011c1d1867e9545bd0248e66a37"
    sha256 arm64_linux:       "4cff1e09197990c1841de28a7f53b0cbcaa52f7d270f0e61d325ee17499773e2"
    sha256 x86_64_linux:      "7ab8d51ecd272e68beccbfd687dbdb6766355c03f58481a1dd80cecfb3c56c31"
  end

  depends_on "openssl@4"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  def install
    args = ["PREFIX=#{prefix}", "OPENSSL=openssl@4"]
    # macOS keeps ffi.h in an ffi/ subdirectory, which the build's plain
    # `#include <ffi.h>` misses. TARGET_CFLAGS is the makefile's append hook.
    args << "TARGET_CFLAGS=-I#{MacOS.sdk_path}/usr/include/ffi" if OS.mac?
    system "make", "install", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpl --version")

    assert_equal "42", shell_output("#{bin}/tpl -g 'X is 6*7, write(X), halt'").chomp

    # library(assoc) is not embedded in the binary, so this also proves the
    # installed library path was baked in correctly.
    goal = "use_module(library(assoc)), list_to_assoc([a-1, b-2], A), " \
           "get_assoc(b, A, V), write(V), halt"
    assert_equal "2", shell_output("#{bin}/tpl -g '#{goal}'").chomp
  end
end