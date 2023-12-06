class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.2.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.2.0.tgz"
  sha256 "3aca9a4af853f9787b0715c08db05e253dc1347770487ac7fc197bcf06035842"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ca76935146c9dacccfa1d8efed8fca62556774c0b2c83f26aaeebf84f08fc5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a224d00dea63f20d3e8dab74031b72bd7284bc543053941cec45d3d5eb0ecf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66fc3101a995b19b74093f741e53e6a531ebc0ac656cbf0d59cd958e597d351"
    sha256 cellar: :any_skip_relocation, sonoma:         "895a95386c0dafe81cbb7972b2f19313a8199858b9ebfc12848f0c94274c6573"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ba0512b29f18089a834ac738a1a59f03beaeb1ddee798da02829ee689365c7"
    sha256 cellar: :any_skip_relocation, monterey:       "175fcd93ca3a2c5d0de5e8aa8ff55d542a063557b572d2e35e483bd29a88fda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b03d2122449ba6515b3d3bbb97f642d99e2594566aeb0077d039117b3151fed"
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