class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.14.2.tar.gz"
  sha256 "f5fa9ff42090cab2cbf1967eb54d0ca03a414cb26295ca77680e12d7c2ea0551"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79694b50d80d2906a1ca76b7923b930bf4a2d17a6c44e8b698200bbd82ac24bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0c8bfa2ce0a66dfb97d479c2e3f2523ce30fc4ec0ce9a09df55c6edb1d82a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbc17d4fe42dccc482ce6e0179b9e6601b22e7c7e471c380fc4b86017f79840"
    sha256 cellar: :any_skip_relocation, ventura:        "6ca47d591f81310c936e205b7a724bfa895a3057f6e39dad5a44edc16f0a217f"
    sha256 cellar: :any_skip_relocation, monterey:       "56164331228d00d8b3957ebde7bd10680db94479e01f1cc77758b40a4d9449ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a3cbc09649034448c2a4eee0d2a4938f4d49f9db7c2e89fa9d4b4b20adfc1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a47bde8d45e04494ec93e6a42594e43a1c3db13c1dba5deb7fa865964626061"
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