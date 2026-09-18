class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.15.tar.gz"
  sha256 "7d9e047faa42e5bfa10b2c59656fad412508ee93bab147c8aaab590a35243b83"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "9c0a3680c1b0a88e7f26dce45211ca0765fa5bad0860224dbda664398c63ce81"
    sha256 arm64_tahoe:       "d1abb7bdd4187d8fc80657cc03fa71f424a309bc9d3241d391307dc85cd2f54f"
    sha256 arm64_sequoia:     "0a73d14fe4a6652a4ec1f93113b5172e66925a805c7d890ba6fd5d0c395ada4a"
    sha256 arm64_linux:       "286122870c6f39d1de733414d4a9829878f0ebc0be0cbc2eacb6c19f1a2a569b"
    sha256 x86_64_linux:      "aa08a2d43795936fa497911f57cb65c20073961ae0dafc942b18342b26a12db6"
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