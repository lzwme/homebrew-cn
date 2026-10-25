class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.10.tar.gz"
  sha256 "cd9cd85ebbb0d26003dc1ab7951802b9913c8ca2e57a7ba5abe53bc659f1ed92"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "3b5387e4605bc10b6217ca6a991035302d61b0effbe00a6dcaccc81db48da274"
    sha256 arm64_tahoe:       "b199d3e63cf89b8343235bd154bf4621c182d1fbbb170d2eb65a84fef9fbaa8f"
    sha256 arm64_sequoia:     "cf00e5803ddbc1eafdc5a341f9cdb6a58fbc4f8be9b884377283748cb4101383"
    sha256 arm64_linux:       "dc57c1efc207d1aa9821abf09cc351b3b4ef80c190b83b210ee5b1f5620d0e0f"
    sha256 x86_64_linux:      "71c744ad8e84d9defc90d3d70d0b548b7282ea99dac7f8fbe81721bd2bdde43a"
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