class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.4.1.tar.gz"
  sha256 "73eaa2d250c8296f25c93748a899552180248e501899f74cd892c308a21670b8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c47a1dd2b41cdaff7b3c7c74876b1a46cad3c1f7877dcf2f3a10d4d196b3ce70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1646e16b18ebf7bca83b4b36c8b7230e0b7f71b16aff2c6092712684cd93c087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2836111ef82209e02e2e0298cfc915ac30328a0c2aa2bea551a7bcfac675d84"
    sha256 cellar: :any_skip_relocation, ventura:        "4ad05904501dab3a07976787e7c9455a88460a21f4bee02fb4f67bdec46e243b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b0ad08fd1dc88a9028a27b6634d685ad63c45c3f5129f381d5498cac25963b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bcc37cd2ba25583df9cf90244e85764e0190f5942214e16922c3fb741b55d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7f27dd90977d58cf7695527fb97be001d91417c49987f1aaf46289ecaba648"
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