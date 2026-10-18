class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.15.tar.gz"
  sha256 "a6123f33f156cb4bb02c3db8d66aa958f7a9fd7e49d9f289aab3281676c2d0ad"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "6ab657237af7eb6d112f2837c10978850a98feaa9bade5564ca5da62031e2f08"
    sha256 arm64_tahoe:       "887dba295ab8dd1309491077c3eb3b9a41a8fbd2eeb26f52cd97b737d6aa85a8"
    sha256 arm64_sequoia:     "35fdabe9cb027bf1da5761cf6da44d4a58ae9458f57fc644fe5b3224b26e0816"
    sha256 arm64_linux:       "c38fa875998c0374c8073a0de1c3e36cb148f889381e0d7693f21b6e3a2908aa"
    sha256 x86_64_linux:      "53d3b213d5f1a2a8ec6221c792826bf15bfb862d0f18c172c12c22f15f8989ba"
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