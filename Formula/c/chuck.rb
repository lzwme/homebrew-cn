class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.1.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.1.tgz"
  sha256 "0bddcb545975536a3471d7c3a21a6cc8d4555bc06a4af0d2f5032aebaa1362dc"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "659da8e08dd5ba63c4ce7a90c64e840f449aa190a2b29169812bde78f28bd173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7f1d58cb3cddb6f787f03005e48d091bb270aea2adfa6df2b5287feda1f283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08304041b3560b0627118ee9d1ff353e2758ccdfabe3fffeac62866e22954b9d"
    sha256 cellar: :any_skip_relocation, ventura:        "1187ff7bf80a49312654dc0b66314d95b7a324b73d35b087ed5ac66ee20f2f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "1607fd45bac6b67c5073edd4de3076f874548e55668d54f0d8cc7056bb439fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "922df211f1295963158f42f9e29a03a89cd0871071ccdff4c3eaacf2d2fecac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9b045e97da4e035ef72183340a94109107739afaf69208e11fb92e3c39fcc2"
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