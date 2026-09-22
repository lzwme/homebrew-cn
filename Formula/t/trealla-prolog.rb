class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.35.tar.gz"
  sha256 "8985c37dc5b3556c42956f1909a0825c1e16c260de84ed2fb6cbec1f6eea86e5"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "8a780f346bceb2cd0eea6976d0179c247ddce022824e9380ccfb67fe6cb77a2b"
    sha256 arm64_tahoe:       "4065a2fa936f1af7fa97f81dee575b05c40b46bbb39685374b10622a19ed64cb"
    sha256 arm64_sequoia:     "10f43962ba3c53352a54544cc87fbca42bac4499e296e063ffd55869509cc963"
    sha256 arm64_linux:       "90623ce0bde4c2888043195c5d87a4686fd198257395a8d9e6cd0639ce2d91f8"
    sha256 x86_64_linux:      "73c97564523627c9cdaf4b650c6923059d36d3601f1e4cb0f73d6bf0fc8e87f9"
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