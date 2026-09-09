class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.9.49.tar.gz"
  sha256 "a0d68d05b534d95f8f6293f3e9ce92332e7a7f8c1b5359441fa6c856bb3f1e61"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "70b051b90c821e57048e55f11538d0533c74b914328f10a383dc88d3df6f565e"
    sha256 arm64_sequoia: "b0e8ddea3580eea7d65b909b6acd80a98352ef4f946766b797bae7e0431e5cff"
    sha256 arm64_sonoma:  "012b9683c68b240dc323b22d45d61666eddfb7d07054e139514bb8b3e58084cb"
    sha256 arm64_linux:   "621cbc333968afb11bea52b86f552c52403dc92a00f8aebf89be4e6697e5b57f"
    sha256 x86_64_linux:  "51ce94b5b04c0da0e2d46259613bec6531c66327d4cab1d723f188abf36b369f"
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