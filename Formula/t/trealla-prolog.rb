class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.10.tar.gz"
  sha256 "89e76494b8a766580a71df50f703aadf5d0ba6bcefc99a09b0289751376df375"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "776841723365044d7ab2de790f8f487d27353344657168da6d514060e38c0dee"
    sha256 arm64_tahoe:       "aff7ef39cdcc7871b5d26faadfcafdd1b66e4ba8799c52811ba796ba0a96e7c1"
    sha256 arm64_sequoia:     "41b10176f05e20e84e00dc2cc099a0d77d85d75d344daecaa188bf96ed95b57f"
    sha256 arm64_linux:       "0feeadbf69fe399c94a6edda2961e540c6006b36464d4570ec626eed0f12ec29"
    sha256 x86_64_linux:      "f429adbcc4236fb0b165895d5758b94b6de7c82e0a30cdfb0e2084dd7122e9e5"
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