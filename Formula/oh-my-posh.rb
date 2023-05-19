class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.7.0.tar.gz"
  sha256 "6e8afa3b5e7e18cfe7489f53eccb66449554dbc1270fc7d4ba449d9873dfdd34"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98be5b34c785fba798ee42a0e1664fb2678da1a07b6f6ac314dce9c2911bfaf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1e698a42a2f7127f586f00a16e63b6686febf4bd008d214f5268cf81d409a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "652d2e3044dab780df739794006249391eae56e2eccac795e0ce30586c068b71"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd8edd601e299d71bdb9e56dc6862a30ac5b77da837a298cbab63108b33d8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f22aa2d1a758f15bc15cb7f80d555c60296ebc2f1193e7cbfb5b9888f3f5b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "74b4e13d32a5cb11385a869594c69656ca2e1941221cb3655ce64f0c1589f83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b860b74c9043890f693674cf0aec3be5c52dd1372c99496dd3e10a4c6c0150b"
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