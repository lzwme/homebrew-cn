class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.3.0.tar.gz"
  sha256 "6672bf32fd86ca0b19cb62af4ed3bbd9bed523ef5c55a63db44665ffa00d4066"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96d8e4e2465e5b9f40ea64b0d46b44652355e35c17b9b46bf1370fc7db3e632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5bffadb5d15b8cec3ffb3a4ed0ea05f2bbb790c1f992f52a19481eed8b89c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf174167334db07e42941e5e90f707fba646158d3a1835b1df431f84e19bed04"
    sha256 cellar: :any_skip_relocation, ventura:        "03822783a257b8d327a4e15959494c64d80cb9343c192cf2f2cdda0b86f16387"
    sha256 cellar: :any_skip_relocation, monterey:       "c712bc7411ce76536a9e358a082d7e4b08646cff386ff85f76a6629d974b8f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33e8cf860dbe1bc7a0fe3f35af0e2d912b822cf4a2f59385ef1b58d65698a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c81a5422b8fbaeabb25de9baeaeebf94251b2875b62c431265fac96830c9727"
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