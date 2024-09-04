class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https:github.comY2Zmonolith"
  url "https:github.comY2Zmonolitharchiverefstagsv2.8.2.tar.gz"
  sha256 "82e082c9b731fc1380706a1f9169bc12ad5de4a8e91b2ef8b7d1698027c442f7"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc06cfed9b2ce92bce784399bbf0feeaab3fa49bd11f643ead501be9bd38b46c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddad9b5da6c7a26129f9b66024fb6b39d835d4e99f1d8c28e75f049e92e6fdc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d30558e3c9035ff1c3dd3c9289a4a4b5340cbd3b21be3db54bd8275bf9e47c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f944ec872ad820359e531cd3d4447d088711e6a7c6d8117d3a28691f92da824"
    sha256 cellar: :any_skip_relocation, ventura:        "02ebe39bd1eb5300a0978ed7b0079014bd0c73780c5f36db1de833f9dda17662"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8b03adf5f32df3fdda57dfe614a21aa88c94b3e4d623938fff69ea3832b18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe13e650570d71157d04c009af0e00f8edb14a68226f8eb690508e25fa7f677"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"monolith", "https:lyrics.github.iodbPPortisheadDummyRoads"
  end
end