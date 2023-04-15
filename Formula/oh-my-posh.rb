class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.29.3.tar.gz"
  sha256 "a1a39bb6f213558c96f654c030eacf640b76ab8cb90c1c85587df14981a6ee2e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1be94b41a74ef054767a48e349cbf670ce1d8a4e5f813ef3bb87ae433cc1956"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873b89cfaf62744195606c5fc25d65dfc22b2a04976f4fd2e11e867f427066b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd87f505d2326f0c522dc7b8d4b04b1e4f8c96cd3b9e3a585c52bd334400d7a0"
    sha256 cellar: :any_skip_relocation, ventura:        "fed0d8137d3740c0c4d0c6bd3b1f8c1ae5e7ce9012e3b5884525a3cecdb72cf7"
    sha256 cellar: :any_skip_relocation, monterey:       "17211a28dcfb23f0dd3b99a7b09758fab8bf64f0b8b295ca7218646af6f5d6c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d177a89ca9a92ad9e708869ee65a9976e991d8444c7d5c1b0758058d7da2dd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b666dcc625ee629234505695ff705581dd2aff45808508547c1303c3b27fde60"
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