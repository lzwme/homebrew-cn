class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.5.tar.gz"
  sha256 "e46f06227463657b11641cf9d23386a2fe2208db2e20345eb6722b0450217453"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "4e219f357d0619652ff7e7487c0d6d58ebbc9275d2263370cafe5122a24f00b2"
    sha256 arm64_tahoe:       "def419350296c7e0c2bfc139c91988b2199dadc34ba5a38ba1ca0781f2559be8"
    sha256 arm64_sequoia:     "558a8e48a44ef0a47736f168c948d237d31cdee9e612b053eede706041118fd9"
    sha256 arm64_linux:       "04e7eb35b7768585f0ebe54aa3f43d8ebd4270770029f84159a193e5e2ce8a47"
    sha256 x86_64_linux:      "3a185958b22702074d77f4bbe2bd8330938e8b2b5b9cce8c8c384961a4e8563e"
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