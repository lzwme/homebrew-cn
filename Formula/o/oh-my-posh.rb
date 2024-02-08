class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.8.3.tar.gz"
  sha256 "185522c865598ac6b95f21cadadef07a89a757297291a4bd0949de1126451f23"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd708140bf7105030331ca27b9d5b5a0f04a8293e6b6d678f65ac7405f55377"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55c846bd80ed12c73c63fcbf8059946897eb5bf36bc7da1ad728d8f0514d6bc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51539b8ab273b07720ca9398c2bad8775faeefb0567d32002b1c7f9c9d94adc"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb0c7decaaf020d6473846c8720112292c4ce674ee5b614dd9c832ea29d5a88"
    sha256 cellar: :any_skip_relocation, ventura:        "2596e5d111c58e84db2a1a49eab4a9e91785ee482706f7d87a8966594ed66578"
    sha256 cellar: :any_skip_relocation, monterey:       "493715dc1133400dcc2bb4749e585cbaf5b667017d5424b1c65aa3bd58530e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244fb7b4ace1654b1cd010e956a2f4905b9c1ad28cb87931392a4f9fc7f1518d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end