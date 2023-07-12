class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.7.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.7.tgz"
  sha256 "a7ec3af3df41521d161054810c04ae81b8e26ea4ec18b6d78af51025832f2e14"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b4f8fdffdd05a1d389c21cb2d5457e13f2dd53ae8e6d480cbacc0f55423971c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c1ad1ca3cb5e615bdbe9c2a47d10a424ab6c487f4ef59cfca60f63e63da27b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c5be7a8308df9a7c02d5811db4c91a6902b280331b3aa3637d8f40399f2dd04"
    sha256 cellar: :any_skip_relocation, ventura:        "ae4c9207798c575e9d80738fe5852f59a4c4051d92cf4c4f13c06a3deb2117b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f16aef9ddd229abede8bb90a293308327fed2e5d2b53ddd981c0e0786f7d6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29188f7ccb2f602bbf884bb5764220f2ba04b34a1b2e4d94f73ca21ef71a8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58740b6a2c3590fdf4f2c6d770abfdef92d218fb1076b0e619c249a6584abe5"
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