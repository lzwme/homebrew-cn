class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.5.tar.gz"
  sha256 "f10cb3205dc573dbca1554de6e8564159279e8e2f82b547f61c387441bf6833f"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "3b477a45204470673c6472ca31d82f85ad519de7599c421432d7a019bb1ad9d3"
    sha256 arm64_tahoe:       "f547dd9d69d07bb947f193258e1d127c7467775c23406971cc794d34bfeeb6d1"
    sha256 arm64_sequoia:     "07fc7d98b14738e4f54af9391f438e8e4ad685fd9eb45f97aebf59e4872ca9f0"
    sha256 arm64_linux:       "4ceb7f9c29c60d58dd5c7e6be760e9659457699b70ea629a016430b78c16a56b"
    sha256 x86_64_linux:      "696b8e4bb702f3f01d33fc9fa178e7c33209b87889be694fbf3b80d41577625a"
  end

  depends_on "openssl@4"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  deny_network_access!

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