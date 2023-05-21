class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.7.2.tar.gz"
  sha256 "110aa498d8d7265bfb950f48e3c5ee0c68da805624702207d0533739b4acf0ec"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9b2464f5f6dc34da31b5e90c899e103e85c66e6eb2dfb6251a00cccb4b70c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f5f06790bd52f2f78537faf52ce0d2286e646b978987086a21a6b00dc398cff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea37b8ef948e51483de583840de32480d2966cb39481c7297164ce0469497036"
    sha256 cellar: :any_skip_relocation, ventura:        "56df16cd9e25db86d1673c2c5eb2a9f059bd3677a28c3829c99194994b96f712"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1bf423c645c00829e926dedb81a4dad0351288063ef7695d73c9c13feb120b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9832d2e71cf5897ced49da23dffb8a575e5b41a917e584727a337f04f287e7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f1ccc7588694baab704df177987965a44d3980944aa9f39a992250b60c9709"
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