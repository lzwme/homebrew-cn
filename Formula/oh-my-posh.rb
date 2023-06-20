class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.4.0.tar.gz"
  sha256 "d7123d917b38901ce52a0d2264a95db20c98f02c4a427b06286936cfe1aea94f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e39470321bf7cd605926f047da55405c266f874ef208fa9165784d6d0761af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27073a7a2b29d1277b7c376b643371d0b817fe7b4fd22366f0b8e8e9aa978bde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f476cf253c55bdc50bf196704b02adbb7abbacd2e5e42b47ae9ea32694b55c5f"
    sha256 cellar: :any_skip_relocation, ventura:        "995d43ef489c1d2c132f9db84e335826dfba4c7b5e6ddfd56c6d572828ff9ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "764272d5839318d8d3bc463c737993994d0caef9f49fb692115b6d2c4aad145d"
    sha256 cellar: :any_skip_relocation, big_sur:        "371bf91c1b9fcdb3d992af21ec4820948b8b6f20fdd14c4c64944d806d359c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9452799b5d31a6127cddf0134a636302752442429ecf7818e95516100d0f96e"
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