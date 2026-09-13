class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.73.tar.gz"
  sha256 "aba7afaa3d41b3ebb3ad51b34f8f760d0ad1fdda52ff0ec3822c3f2bdd4b18fa"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "910070ff6438a9dcfd467fdd4c0a50773d440e61abcf3aab0330d4c8b0b13f28"
    sha256 arm64_tahoe:       "5ececb8a28b394531f92e97956486755ef6ac618019be932e1a9964c4e77495f"
    sha256 arm64_sequoia:     "58e3d4c5411b65fc579cc28b444e0517fba055df8e5a78e99c985fb9dc176f69"
    sha256 arm64_linux:       "70110c389cb22ba81d4e36a347ed0a2ec490ce15cfda9d2842ea838888204b80"
    sha256 x86_64_linux:      "5ca8499823eeb9f633850b0f19ddae492e96086d96de508671ff76ad6013c923"
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