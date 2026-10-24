class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261023-git-e048c09.tar.gz"
  version "0.3a-20261023-git-e048c09"
  sha256 "a140ab809c59dd502a54f9d0be334b0fa8952618c7e69928a4d29855a325660b"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7de49c96f7188c35a2235e0e0ea1ad9ac79de8ac25b9e3a0798cf8ed7813c8e6"
    sha256 cellar: :any, arm64_tahoe:       "bb5a7092e5319b309ec77d82c9e1b2ec6dec7293c9373848af5eebf7aee9ecf3"
    sha256 cellar: :any, arm64_sequoia:     "0e8fc8683416cb80cb8d307661287906846881defaece04d1e89b8927f33ddaf"
    sha256 cellar: :any, arm64_linux:       "6479eb07db063ebbf47a2d859ab07c80893ae0d6efb53c4f7b03d6189f9cac14"
    sha256 cellar: :any, x86_64_linux:      "36f6e75bbdb2627494d83410b876962c50a238c4cc9f080f7a239a55869f05aa"
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