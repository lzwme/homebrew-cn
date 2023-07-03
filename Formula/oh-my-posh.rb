class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.6.0.tar.gz"
  sha256 "7304f38b72e14ecbcceaafd42b05c160ee2efc2508424de71b1cc00177c3339e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fcf42f5f35f2412698a801a531b571667274f10a51f46413fe48a9eb0fa1167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e769a5efa83bce782c338b6da14e776f0041aab77ee5a7271f6180255cbad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "827939150655c5e04f263a9b4e682577c91e1a3bb6be434245c633f8c022b7bc"
    sha256 cellar: :any_skip_relocation, ventura:        "6e75d2dfcff3fa1dbb0649aa0c665439db1d424f7bbf388095ad247d50a1d827"
    sha256 cellar: :any_skip_relocation, monterey:       "2180b707e882577043cb8085c7b9de03876fccb1956889959f18a222e8e9e236"
    sha256 cellar: :any_skip_relocation, big_sur:        "8613ae1bbc81732a12161816aa2caaff83e517d36eb6de7a6bbb526638074394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f0a48e06af35028ee54c9adcb58b092d0dc2dc531b58fd0b923e32909a8845"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end