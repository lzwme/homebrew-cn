class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.2.2.tar.gz"
  sha256 "d0ca16c07dee22aaf408c722aded812d7eb4eee11cc4cabb7048d0b3b8f4a862"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "babdf75c33970e11858ac878422bb0b0c4047f8b61beab9b115ecbcd14e95c3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e541e8eb4b3538831aa30905874a124ffeffea29f723476f199e31841fcc12d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd0c64e646d2677f9d8dd691a17aa2d78b22adcc30b28a44bf8b5cf0f3a01ed5"
    sha256 cellar: :any_skip_relocation, ventura:        "9715b249724ab690d15006f6a033e829493232dddfb0f9096f78fdd98a3a6a81"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab24e26df17d6f4f3b1fe72caebeca37b76e7c5bd3fa373ab8a8919917b73c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a6b1927682599027bdd72f77f68945338d9e60273457a3cb6aecb16e16e9484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471f16fcaf7644b96e0d27339b41cad4d5e1ad1e5ea468fb866fbe651af4e1ee"
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