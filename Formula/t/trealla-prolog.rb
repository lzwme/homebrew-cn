class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.40.tar.gz"
  sha256 "d8e2038fed88927583190bab7c30f475c78c31ec9aea65e2be85afad1971ef45"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "7743d9cd8a53b99ce30059a01f44c81c2ed33ff7b334b6b6e1dd342a6de793d0"
    sha256 arm64_tahoe:       "6d977c09d0f5115c51d7771ca6fddd7dfd84c1928fac97c48ba20572d78b2fd1"
    sha256 arm64_sequoia:     "8a1b4dd5b02d94722d9008f9bb5bd9765a74964c891af38d2a2da4da232c29c7"
    sha256 arm64_linux:       "c54e18e31b7b6b5987b86658e1176ae43cf11c4b36e559f9c548a28487eebc08"
    sha256 x86_64_linux:      "ae5d49a2498332b1c28da7fd9242d878e7483ff4d9509fee3df29abbad377600"
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