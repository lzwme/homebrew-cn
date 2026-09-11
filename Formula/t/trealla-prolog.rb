class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.63.tar.gz"
  sha256 "a0d1b3f1a79574be8764a045777c0ca602c8bcef6cbc6192b79f3eee8f0c19e1"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "55e8a0b411d45267f98cdb1ae12db723b526764c97024a1e7f1dd94bececae84"
    sha256 arm64_tahoe:       "f2dc2eda8b918f64c01d7609b37a1a8b6b5fb25efe3f64a51914f31f74da5a4f"
    sha256 arm64_sequoia:     "2d94cac568d85182421a9680df52404ec3c9ee309842589e389f6a1ad43425bb"
    sha256 arm64_linux:       "134e5149937f79841e56d7090bf60636524d39336ce3406f58c0d00078fdf464"
    sha256 x86_64_linux:      "cfa8db2459cfd361ac79f98704c4a417c83066d75c47b0744d71148c38af7508"
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