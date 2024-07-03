class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.18.0.tar.gz"
  sha256 "d20382d7eb6a93b8b6fe508b87c83eb1bb600a0443f173ab1edef0e81ea9f66a"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f3394a6ef2812fdbe2bca41f4dd480302b65dfb709431134fb0ebd7713c963a1"
    sha256 arm64_ventura:  "3dcd4a851cf6a6208696bb491151b7a7d07df463473f2ffb80884c31b77984ac"
    sha256 arm64_monterey: "677b37e5a8407d932f9a28a3f296c5153923770446a99aef749d2b54804eda05"
    sha256 sonoma:         "183e3a4ddf6de1d238a48168879d4b0493adac3636d57254665d0c5d69289241"
    sha256 ventura:        "dbe2fb1ef9c806a8fdee1dfc983852f4cd01fe8043f3829034a7318819d42aa5"
    sha256 monterey:       "216d6689c0d2ee7a6b03437c7f4892fcc0b819b933884c846ad7a54ea158fa7c"
    sha256 x86_64_linux:   "a60b36eb03ec40707da2ac51cbb8d12f1a3c0186934785e78f650fa16d3776f3"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end