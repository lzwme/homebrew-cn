class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.8.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.8.tgz"
  sha256 "84d5a2d1ae7e6a7de70fc10b14d4600e1a56d5e759e91985b689d469173ceabd"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e876f9959e4b1b6ae1c431004beb56fa24047773bc62b9821a950a603e7ff54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77c69a15c878e1ff2f0061e28c9f6cb6956762554591208373436a49dd7cf560"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4579bc6c48b41268015c2bf0e3bd159bf15e88ce1833999db57518a0ea9a9ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "0df600f920abc65700bf028149e766997443c36c461319d08a8ce5a242f0c63c"
    sha256 cellar: :any_skip_relocation, ventura:        "a9190666f98479abdd9577d65112a40c62036f112f7d84f243dd75f3e481410d"
    sha256 cellar: :any_skip_relocation, monterey:       "62a07e94d75b33a7da945e0ca3f3f1ae1a18ac6a25186a7e2818ec77a697e2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1b4ba08cd6cdb089a754c5ace368fe7896963a8b4bae480f303fdebd29c9b7"
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