class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.15.tar.gz"
  sha256 "d5bc06e66472c97be6a783bd1b3669a028a0c75699ce488901c046094e96ba6c"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "b2f30f04fbf63aea117bc878e5937c2179f92d95e3fafa692c1d0b74a81c87d7"
    sha256 arm64_tahoe:       "bd64c10345b294ed78104b8a3b0416414fc1eef147f96aa8529d5f1315a2e416"
    sha256 arm64_sequoia:     "d7fc9cb3d8e9d93c0a1ddabf14d56e604affaf1afa067e80f3e8508cbc920f98"
    sha256 arm64_linux:       "757ff9ded59d5b584cce92784eba4c9e6f5d59f228804774d0a43be5ddb1cc0c"
    sha256 x86_64_linux:      "c1048a2e1cc551f0ea3ccc337adcaea6441eeafc0a4b14d5e24e2da25358bcbd"
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