class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261021-git-4cfa19f.tar.gz"
  version "0.3a-20261021-git-4cfa19f"
  sha256 "ef498549e2cc39ceeaf7e6af965ac93d4cb91d0770e117f17621526732211ba4"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "997d6e894aa7af3390fcf9c99d58d3513d2b40d10d4aaf2b5ba6c41042f726a5"
    sha256 cellar: :any, arm64_tahoe:       "daf5d6a402540045e40907d1dc7ec58d7e17233c7c153ee5ac484296e5f71aca"
    sha256 cellar: :any, arm64_sequoia:     "450036cd2eefc00ca9719ea463c2572ee8109bbce3a3297977a8ebfcb40a9ef1"
    sha256 cellar: :any, arm64_linux:       "e8f585cc2686e64fdea40a35fe7f13b582d3cf780b333d76223c090d9bc9ff47"
    sha256 cellar: :any, x86_64_linux:      "8f780c7c6932e30ed5510f1045dfa695340632e1c508b3e6b0f531bf57e92a48"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end