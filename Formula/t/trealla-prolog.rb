class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "f37ab2c78d7ea46681ff3c76bd9aa009cd9a98db77db68bce41b52fc4a64f9cc"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "5bb6e6027bc1e73cac5786d8f44f57880e387d7182f806f2cbf5770dda686c25"
    sha256 arm64_tahoe:       "d140e98bc9cde8fd049510e7fb696a6153ccb1f0b107c02081fdcbe702d0dcfa"
    sha256 arm64_sequoia:     "3d4ae301315df8d6be404a184d448d199c0ac6a0945bfad0273c242751dc2d13"
    sha256 arm64_linux:       "c905e512ab47997c27b3d2e65f909ee572394b225e399d8008da636fe41e5457"
    sha256 x86_64_linux:      "b118d4f472f16feec20b87ab470de03e2f958bed826dfa2d293bf11363e63cbc"
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