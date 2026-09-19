class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.20.tar.gz"
  sha256 "d1dca13f24f4ba445fd6d2fbfc1a867539c92ebe085d8f51469b3aeb18737045"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "0f6de54720c918bd3166e1751cf7530265c99a739f1ecb7389d69174ab962270"
    sha256 arm64_tahoe:       "0c3bbe932dc834a2f2b7bb83e147efe31e09a74608a7cfd785e92cb79e166d17"
    sha256 arm64_sequoia:     "9fa5d86a163f0e2775b9324a7d9221416bd1433e6be9d5061af03d3e5b85d7e6"
    sha256 arm64_linux:       "b994293138d76300a8cb941d5869cc68cff65bb293563a6f0c100f4b9341d428"
    sha256 x86_64_linux:      "46a150e0e10797a073009105b4ab1000c4446cd6f9a703d552761787f3ccc8ea"
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