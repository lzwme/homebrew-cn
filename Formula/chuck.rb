class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.3.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.3.tgz"
  sha256 "33406570a817d1514bb49defd3ca20154a6bf5a565218a704a677f6da447f5a6"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a132fddda92228cea2198cc7ca157d658c91ac90eac8b70fe3b92599b965bbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0695ffc28558c74e557b17119b988828cb380b43fd70b55f98b42a419cfd182b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8e58d7dedb3dfb9368fb3de7750d2e7d5980dffe8611a19a9d2ae72d0c0540"
    sha256 cellar: :any_skip_relocation, ventura:        "2896c7eca11e1152f9fe94e07c53380702353e612c9c07be1a80373387569f67"
    sha256 cellar: :any_skip_relocation, monterey:       "615111836d49ebe0b0895b20975b3b8b92b3d3dd8601ec70dab50dc181e41d84"
    sha256 cellar: :any_skip_relocation, big_sur:        "36fb6a40265dc6ad7559d2452a846f57df6fb0ee687c883e41c6d22e207a03ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c54339e4305ad9b76fb7eb02fc8b27ac768991d939be73b95e0950dbf8cb5e8"
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