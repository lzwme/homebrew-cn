class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.15.tar.gz"
  sha256 "d0fe64347288a08c8b9c594989526b83b734ba8eb867e512cbb0d62b71a38fc3"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9867442ebf941c94d246e9771f7234da0950d1e1d4d7deb7abd7176d9190ed13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa190cad52a55322cab225e7c9ec011fece8d433efcac4ebf97b871bfbe8906"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c4fd2bb1ae90040c4fab68f63c449d0230f6788710fe851fbb5852069d9903"
    sha256 cellar: :any_skip_relocation, sonoma:        "407c172a1a49ca868e7b365a2d5fefce69a627352f3fabd33cbb5f491d34ddaa"
    sha256 cellar: :any_skip_relocation, ventura:       "823a9697bff14f5f8da1edf2ed0881e1e1bbc11dd4e7c9be4045681b27f138d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d511fed6e0cd47868ee73d8f290d20fe2d1f859406cd3241ed36db4156ccd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1dae52c89d437c815002a415f31fc93ed89a442cd2ea535f235fe074e014b70"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")

    output = shell_output("#{bin}goose agents")
    assert_match "Available agent versions:", output
    assert_match "default", output
  end
end