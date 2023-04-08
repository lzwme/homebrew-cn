class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.28.0.tar.gz"
  sha256 "f7140752cfa89269988e06e48aa370d46b5413104504a556e4c285cd3badaa0c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a72f6a3f2dd8b07353d5596c7770a2c12afe72e56b48ed64f7e81212fc16ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a808f75ddc4abb5ee221d75e47b09198c5c5859709057900d5b253b7c7ec893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f5d86396a1f69fa99238f5991e3c80830e3006b4fb309f7f9e67765473c07eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6ad18db1be2ad30cdcd010b5f015aea5c3b594a6830e4615f6d6e875c73a08"
    sha256 cellar: :any_skip_relocation, monterey:       "af549f1862e45b2384b21581e55cb8d9d7a2044c482f920c4b0330d67a189b47"
    sha256 cellar: :any_skip_relocation, big_sur:        "44f7010d7bbc264950cf093296d8665256ae309abbd65961684dd6e7901ba7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51663928997fb517ffd6cb485dc2883b734816aa8115e428240bafb72b62cab"
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