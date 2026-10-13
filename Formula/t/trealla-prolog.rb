class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.5.tar.gz"
  sha256 "e97c9f95e2b7ae1cdf8201cae5aae59e6f937b04221997d08ce457546cfd6023"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "ece6680c7a540c2434e9d195dc9cc43b284675b69fecfe14ab966c3389c2bc04"
    sha256 arm64_tahoe:       "09de7a461bc7b533c5eef4bcc07b6db30f090b56aa5828597da2a631690b49ce"
    sha256 arm64_sequoia:     "4ab7c06c833701148ce1890206cd3ddca196dafd6806ceaed93a2a044de14f7a"
    sha256 arm64_linux:       "22ca8d428e5c05d88e3305245ee7bf834d665bcf431dffd0b852f954e561813f"
    sha256 x86_64_linux:      "0c5e1e05a53a07f6c9811c3e7f2ee1e274225fdd22cd63f5a36c338868f6f2c0"
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