class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.31.5.tar.gz"
  sha256 "2a7ea39786873cff1250da81f03baa7065e120bee4f844d927ad2003e352616f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "367002a26fda305b4b4baab7869c0acbe65415e3a37d34d113829079fcac0f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67f5f439831d695e0a7ccff4115538995f745f57cab1b467940ee8b9c0d14b6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76661009fe1c43e945802871786078a880ded3324d465a7bee1c34504216ac8d"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7bfa7859164e807bf5c2d043b7e6c88c8435c18634c6fa1696087a59d4a5f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1925e8ce528bb8b294849a27c7b21761d6ad122fcd151a16756f4fed76cb178"
    sha256 cellar: :any_skip_relocation, big_sur:        "e64f00fb97f717c67e877d6bd168ea607fc6979e85e8fb53845fdd39badb8a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48be9adfd2f8d6c85d8ee536214d74d3449c4b929cff8f655f0c5f80bdd2d527"
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