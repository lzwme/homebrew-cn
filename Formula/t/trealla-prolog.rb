class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.10.tar.gz"
  sha256 "1e50744ed0440922b06e9edbffc70324fda39a763ee0f8412b05506d02eea153"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "a7149f8c081e9480b08862c0d3ed46250e98f04d230bf0ef1ea8c057af41a955"
    sha256 arm64_tahoe:       "039ade0f4811b158719c3caf6d02e846762b3f180ea3d5cf0b50510d9c78cfbf"
    sha256 arm64_sequoia:     "4a18515fa4d91fe090f8a93d5f17336eea05b3fb8bd1fb700db922ff6c1cb520"
    sha256 arm64_linux:       "88e52bb3feb86bd9d4bcd8c533585ce451f8c4d90273db75d53bce891eb2446e"
    sha256 x86_64_linux:      "5a9aa5fcf6165aed62dde521f0f6084db966dc7176621970941a7cf45c8c9f5a"
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