class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.2.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.2.tgz"
  sha256 "ea1bd266c7abcccac6bbcf4e125756580397580cb61c763e9457a9aeb2ec2328"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0592859f2b4ff21adf9c8a76078076aede2a2dbcaadce1cf1a7b6085518537b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3cfd1ffa6b997bfddfb6b65670a9603dffc303a2b888d49bbb5bcc0cfbd9925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eadc152190d14287518347ddd845b89a18431ab99b7c01d4563ebad6000b788"
    sha256 cellar: :any_skip_relocation, ventura:        "8b967e8639770abf3ca2c5396c79b482cdc34dea5977ff25df5c31cab735c210"
    sha256 cellar: :any_skip_relocation, monterey:       "f85b33b01fd3acb9428b150483715ad099ce723c37f1e7c23d0c4d8f1eeb21b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa64492ef87a24cbb92a9d823004d41173d58fd875c046f9273d519831a88519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519110f48ecad47479c711a1f92bc87dd7e81f5117e50d6daabb61fbf66b90a7"
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