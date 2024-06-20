class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.21.1.tar.gz"
  sha256 "bca4575ecc2b00c3147f23761fac807ab4836b119efd6823fe5ab741cd17dfdb"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e9c8d65eb2b1fac581dcf51e9c4d92f02a7a236a89a2361f60b1440e30a5be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2a6c18c2c9721f45bd825ce951fd231fef36ef57787c2f7efb0207a1521427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec19018e6b011c9c7eab584b803bc3b1789b4566108ed9ef273348fe9feb1ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "86ef6bdeea5f3cbfb5018a91c7ba7585c688791d676992be3b6d3ee95c4ae77e"
    sha256 cellar: :any_skip_relocation, ventura:        "6e9d4422b8aa61250ca2173bb3b76928e902cb8a8b0606706f06b35ce0d20b96"
    sha256 cellar: :any_skip_relocation, monterey:       "2e5e95ec3ee84899dc7c5a461b4d312c8fcc45c8c7bacdf949f16bf85981bc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0187ce3d2a171ba7e66a1d19051ab5cf599ca2aef18baf7b681d4368db6e4ad1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end