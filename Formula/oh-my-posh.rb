class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.26.0.tar.gz"
  sha256 "3ab8a89b673247e616b9c418912c044e0376cb7e9a7001dffe5904514a622b75"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f2cdf4b03b2c8c533c735118aed4102553a70710497adf293bc68bb5eef118e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "888569d35441ee50ca7a2677fd6c0e037b6957cc50c43ac21045bdbbe0c90c9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e83845504c16c40cc16a8a5d9cf5ab60e112e54ae4fe7176f323ed117b3f83f4"
    sha256 cellar: :any_skip_relocation, ventura:        "9a2dde2fc2eea4e617972677949ac96c707ad346b89e5baf98363cd0e0223a39"
    sha256 cellar: :any_skip_relocation, monterey:       "582119f9118f06dff8e106b4eedc766d228ce9d9443b168826d007de511549d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "09cc9d17777df4f3d80a0f822e745d7236ba367497b135a3e15e68ec40f7d67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cadb8d8f4d708181f3682ea1e9428363d7c00ba8cd6c12f0d6cbe31a953964c"
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