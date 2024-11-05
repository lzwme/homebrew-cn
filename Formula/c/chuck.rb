class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.4.1.tgz"
  mirror "https:chuck.stanford.edureleasefileschuck-1.5.4.1.tgz"
  sha256 "096957729006c85a0c7f15ffe38f1c8eb85b06a194a3445986996555aabf28a5"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "853340c256a84df9c2593a79d32fbe08effc6f705fa4e24a48d70384f7c92f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c47a57064181ceaa23582e1c43927353bee668b98db9670f67a62cdc555f99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca6a022eeca68c0517b204f2d9e10d5d192739d9e5f030dc7e45aafc3fb2d400"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48dfe4d72b95e522ed5535e13b5955a4b99dd3967b67d499335cb392b505647"
    sha256 cellar: :any_skip_relocation, ventura:       "20aa8fd4a602fea1f1ef105f05671f5e3f4a065ad54a9717d1274f6f706a888a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042b044c6adb5be2d8866b4e0b1876947e01f68eb416d35ea8aaaa4d99aa7d5a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "srcchuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}chuck --probe 2>&1")
  end
end