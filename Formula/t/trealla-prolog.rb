class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://ghfast.top/https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.25.tar.gz"
  sha256 "f266e8bad59cb0311d4eb2b9c8d8aefa28094e81ce2c4d1945ebefd84a896e3b"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "4e0f104360ca1bfbe2534cf1e20b030065b7eed6f7c096b49175e0a15f1f10b7"
    sha256 arm64_tahoe:       "9ab321cd98b13badf38aeee7588fcddb9bf64cae7aba62a4096a1b60de30fc5f"
    sha256 arm64_sequoia:     "d9d994f6eabb89d2e782dd31d833bbb20651040523b292ef9cea5ac904f5b40b"
    sha256 arm64_linux:       "bf263cd27a1d6116e8f41936a9c9b542cfd6e968cb4f2a59f39746ceaa9006b3"
    sha256 x86_64_linux:      "805cd2802a655bc182a2cf43d563d225c6e509105788e7e045e8b4a67afa2546"
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