class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.31.1.tar.gz"
  sha256 "d4025106176b1ef879d643cf3a74ecc7c5393d005edf6330da141443ed640da9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f527ffe172c193f3ad114efe3d4c2341b33f617b537cf06a2198802cec07bd46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "322ab65ad2d38959cf853348e67c1d69c82cd4195e401a2c71fc79dbbced18e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc4337d1a6a3d75a87a10125b036ef093ddd2b85cf485d30778351d439a47e0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "87072666e3a1befc172e3a91da86ea4ec8148ec07077d532ad0e30abe268bf7c"
    sha256 cellar: :any_skip_relocation, ventura:        "6a5e06ec178e054bd64a5536de473c75da23525d665998c66bfb7e29a18c6fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "bf35349352b55ed3ca4084ad093d0023230746eb51dfc976357819162fe5278d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7564e91dfd3b138ed01f78ed3012456692d79419a6d962210673a8380ac56d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end