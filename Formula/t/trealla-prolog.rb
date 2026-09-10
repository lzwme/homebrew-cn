class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.54.tar.gz"
  sha256 "6c28db8d8d8aafb0eebfd103a623b528fb71d793974e9caee2e9bcc80fe46692"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "478c04cf16ac01fc5260c7db97bb6c327c74d05bbde59d9c91c782889412f76d"
    sha256 arm64_sequoia: "71b7f96eb47393733981e0b8700b30a97f33cf031dde1b7f67a8ccf18ca8d794"
    sha256 arm64_sonoma:  "7bdf0a66abac3ea95d948c256567ffe6dbd9c3a50163338297874bd901420085"
    sha256 arm64_linux:   "bf4ed1b93ff52c2d1cc60a37e077f9a97641bff7ca4bb91dc031c2a3ef8abe5b"
    sha256 x86_64_linux:  "13bbb9c27bf2646e046b33926510c898937eed48b6f5f603ec51223d0e82f6ce"
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