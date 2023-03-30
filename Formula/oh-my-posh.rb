class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.22.0.tar.gz"
  sha256 "311e7c5b9f0c21ca33542cf978d42699fe11d17ec026de5b0d929e6d982ee574"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13419c9fdd07c5fd022ad774cf8212b349af3549077f07cb349bae35787fef34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a373cdf8751403178185ee5f391f6b970517e01d5ba4526f453dcf4b92eb6e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e5a7832655db2aca25cc52923ed7da8fe1d1fe611250f0c438b8aa786f3f461"
    sha256 cellar: :any_skip_relocation, ventura:        "654e187046d7593430a5a08c25a70ce2f19c1f24767b9acb397dfe0a90b257b0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b40c5fa5fb3d18945f08421eaea4f62901eca6534a6e4a2af6b8ef1298e539c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccdd46e3b1f5bbeacc661f03c5c7afe2c75cde44254d6e4a44473d6e50273884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ce8fe9adb1951a0bfe390244b917ba5d6969213a14a6998b278cc2545ebb5d"
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