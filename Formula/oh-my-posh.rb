class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.29.0.tar.gz"
  sha256 "75eb30c8811c4625352fed09951fca9f8040eb3e0cc61a77e2e6cfe0cb0635ff"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "012ec1371e62ee7a8348a3b3e7ae3fbfbddf27eac7851a0da49e12f3965df0d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc98eab305bba834b3f7c048a29ca53cb3244ca84d9434727de6397373935d3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8394fb1adfce7bd726d07d3299a3d08b9b153146a78b90658f3bcc9b85951298"
    sha256 cellar: :any_skip_relocation, ventura:        "be56e9ad1b70dd68a6b1807cb1913e4eb9bc8d35e835f455c0e4a2e9ceecddc9"
    sha256 cellar: :any_skip_relocation, monterey:       "613a30b57df2def4e9d1caa49c8b82e39b1b40106e87055a186f88db4a951f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee51667adc9d1ad9de62cb5c2c74c661c6da978eaa3d337b07f527b91a6db9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db5d4fab50c0fa18df6556ec89c111ec2e6ec83b92b63c11090e0d5d591e79c"
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