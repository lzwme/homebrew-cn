class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.7.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.7.tgz"
  sha256 "e7cad2aee902c71d080cd8f5bb80a905d84d1b68f1b262ad180f78c259d1c0c5"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f0c3fc5865e5590011de0a47665b9cd561b82bf4c91f6c409357f7409f2dce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fd25072745fb040d5b46dcd3831d56c93b10f9acf25f6f47b6a64f6cd1b101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971377826ad9c588bd3d8f7a041bf7405a01d0bea36b0e576dafcef47fc7523e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4af57f1ba7dfad8d00b7aae0a69f48a7938c8c22d22ef0a746108f0e31c5c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "acc5cf10154574a8d00ba43ac8fbdb2bc59fc485ed5b309815845e87690d35ae"
    sha256 cellar: :any_skip_relocation, monterey:       "90e16e1a4f310cc07a40da6d0fa46824c465f99e3662b7515a7bd29a093a542f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72878e7a283d383ba814adfde77ae6afe1eb3ce01f778e1846df4d8010b9ed46"
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