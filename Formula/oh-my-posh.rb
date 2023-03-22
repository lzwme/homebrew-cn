class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.14.4.tar.gz"
  sha256 "566a6a2c5ee38e0386bd9210007dc9e909bc2f99d1e36ce8a990d2d345c92ab9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00da7b8b2b529b472aca7a005ab1e89a188d4d2e198d10d6047395081b1cb905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce9ee2b318f6c6d0e923bae716bfa398f2a8e222d4f8147716d0a72f4ab194d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4dc15374fb3359a86a87abf2cb4102d5800f24f66074729ce49515b4fac8ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7c2f31b7b63d3119ed156449d7f041bb1c7bb70605f592609e7d1f2e7debf6"
    sha256 cellar: :any_skip_relocation, monterey:       "b690221e260d1dad54fc3049ecf841b358fd670cd1ce839c727a4d138063fe74"
    sha256 cellar: :any_skip_relocation, big_sur:        "a865d8a46c5c26447bb489c7e33c97461331be26d0d379aa8420a4afb1e79970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e972774635130bebd3a816516958dba2a6489cc6e445269a390fbd495fe868"
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