class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "d430ecad03097ef8d8daed57fb79bb5eafa797aef5a0096ea577bef518c54d01"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "f0f518fb36ca014587ffee5942480c49d8f1acf71631818861da04c8aa98574a"
    sha256 arm64_tahoe:       "9de36445a69e49d24e98c6f81d8c2f6a156ecf73c3d4a0c61cb37d8cf25dd00b"
    sha256 arm64_sequoia:     "8aaeb2e285163af0b07272e4923ab740bfe92918690f902ba2e5be07d02ef06a"
    sha256 arm64_linux:       "8787638d96a2a607f3b293fe5a87abc7587d35320c436d4380fa1cb897b538ea"
    sha256 x86_64_linux:      "dc69104af26020517c91ff85532341f42ad62fb614ad4c04d982882044fff7c5"
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