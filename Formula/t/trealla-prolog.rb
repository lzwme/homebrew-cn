class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.20.tar.gz"
  sha256 "479279d683f57fef0d8d3a86c049867bbcc0b7929e48353e6ed07522ba9589d0"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "c8a529a31b423541d4cf07d522fbe1526b8c4aed5ee7b1a60f00b59613b50787"
    sha256 arm64_tahoe:       "1dfce2b8752a2111adfce5088a113581d4e1d7a9af36b62fff29826f718510ae"
    sha256 arm64_sequoia:     "e6ea577a37c5b36315cba96f579f5a572949cf2f9dd4ffc297a63ee6104469fe"
    sha256 arm64_linux:       "f65af3ae6c002bd73b8e74b485c123f20d50a3caffb928c9f188828b7f05b327"
    sha256 x86_64_linux:      "5abe264c5cc624902b2670a6549227597e11d7f5e150e14290212dc756dbb773"
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