class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "8ed486503be67caa0308a267621f44addd9e562c331ab365ac7c006bec3451d0"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "d4d2e52423d8d1915901329ad94f37ffc44ac7486fddb9dfd8a261953ecce949"
    sha256 arm64_tahoe:       "f26b12c65913b43fc84ab67cee7a11d4514decea85876a530a6ce5c75c83620e"
    sha256 arm64_sequoia:     "e44c064be800008e23fab4f4ed43b2a9de64150a60eae5913455533221bd82ad"
    sha256 arm64_linux:       "4640cbefb97645d4448a2a72fb0048f6ad1743039b5f027f67c00a50feed8475"
    sha256 x86_64_linux:      "82dd10875dffbc6f362d8673e524d909b8e87e0bdb42a2c075c1b5120bf70a57"
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