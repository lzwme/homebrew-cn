class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.6.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.6.tgz"
  sha256 "6d2f3b0f718962979f97573c2d468ab70e4d9d2842ec1f34acca7714d9fe8baf"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c9631eea8549ba23ec9a8c1b102501dd29ad38084049685ffc89c75bd8474c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ee0b28cd4e128145ca36cdb6354d5b23bb05da699cf7f8bc02d742b579283ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da9ee5bb4303555b27bea2f978689affa157c48f425f90ee536694add45532b7"
    sha256 cellar: :any_skip_relocation, ventura:        "2b35264e7705c0bcb7a7602efb1d93a5297e302b5ac3110c85c3fdbc9785518d"
    sha256 cellar: :any_skip_relocation, monterey:       "39ca68903a5238bed191da6d63d7271e6783efde7aa034a4f7ddc71a807d380f"
    sha256 cellar: :any_skip_relocation, big_sur:        "85d55e2c9efbb03556eab888836046763e7868b25bca200f7bb29ae93c0d96e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580923d1275b778aeec1b35f4490ec1376f261022262d34b49e61f2fb88717b2"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end