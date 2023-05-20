class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.7.1.tar.gz"
  sha256 "e9283b8e25d40168b7e7f597e537b341d4ab6f0877ff4572d241eaf0d68d4a17"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49eb65dd4a68b2c8c6d47e272e9bec2047da8b10f6536f29dd07d9064262a61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d01fa4b2561b5c0dbbf7bc712d53eb161bd17615c3356d1f32b81bcfe15f42f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d319508d8106732c332da46ae28f33f4488875bc7bc92028c0188e75fc00aa56"
    sha256 cellar: :any_skip_relocation, ventura:        "fcce8c8aa691a2540af99124cc5371a4303ea2191bd5aaf782a2ebec91b3fa43"
    sha256 cellar: :any_skip_relocation, monterey:       "8cca9e5ecfb9b0856e04acd42fe5f89748e9aabcb2533968087cfe5438dfc469"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b421a08dddd06c2b95bd55d8d51a61996e5dca527548e6e87e2ed1227238f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6946614717dd0918ba82692e58ee8db3bc379df891c62172830358ac1e164d47"
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