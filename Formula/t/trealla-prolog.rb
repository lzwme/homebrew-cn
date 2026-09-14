class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "3bb53a780f08ead2075ee7d1cddf8f8489422f6321cabe1fe7335079565fda28"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "d525efa624755290183491388489d74bec0132e6a1da068ac8a959c26afeb720"
    sha256 arm64_tahoe:       "62a0fd1942d7b73bc9de19610f9973358c2e8ea2eec4e0adbc266b9c9635828c"
    sha256 arm64_sequoia:     "a2a051b616d8a565531076cc40217815ee037843e7253341ee3a10e2ce6d5f32"
    sha256 arm64_linux:       "c9093b92df666835be4b696779579581867b9bc1ba5347b1075c3b42011fe8d4"
    sha256 x86_64_linux:      "893555bf5e816d79dcb321c1a1346eaa28f6e8e19b5923c9e9334461e2d6204e"
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