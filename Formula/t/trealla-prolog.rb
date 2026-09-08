class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.47.tar.gz"
  sha256 "a0ee0fe06600eb4e125d488024adb1c97fe5f2bf280b14340084e5e273087400"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "51128e8ec76abf767b4810cc8f4248c98f65f35c659634abd67d9e65cb219e3e"
    sha256 arm64_sequoia: "b4d68ab7613c1a154efe19de47b19003143af415c3a7dbd1d97d206a87d62f16"
    sha256 arm64_sonoma:  "b126f6da9deb8537de92d2c66fa9c37c40c0d4070247e4e02c67004dc66263b5"
    sha256 arm64_linux:   "587b03c0b95d4e677b155a377cb20794375397e8d4b7c0f91e5ac1375ee47751"
    sha256 x86_64_linux:  "6548c9643319b1721baed3e1baf69c98e50454bd8a6fa0f07ff9f924f7c16205"
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