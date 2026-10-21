class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.20.tar.gz"
  sha256 "f9ad11adb4e5091c5968e5b46b7041b3659473d12a39d4678595e3f3233e9cab"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "c82dbf6774662c03f1da149340414d48949469aa090a72860487181063132e9f"
    sha256 arm64_tahoe:       "05b1c858eb75b450e94bf9047a8d0a06602ca8ed594c3d4016166bd32b5adad0"
    sha256 arm64_sequoia:     "a2a21910d299588dad987d3acb3fa17d7f306266072a9363260e696e63834cd2"
    sha256 arm64_linux:       "12f134c29d741d2478b9d103e0ddf7c964c7cbaff2ccf3297c099deb823cb352"
    sha256 x86_64_linux:      "07a759a2f182a12f9a263c6bfe45f6fda2cd7593a7aa67b7d64920bd3579f321"
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