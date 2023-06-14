class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.1.0.tar.gz"
  sha256 "123137f94643490faba1054926ba80045c4a7b83e7a5a1679012101aab599b0d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5653c451ee46ee582190102d367079222b02d66192c15db2212b4abe60a8f1a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e523e46a406036ca4b18fac2ee7b3a2a4e383eb24608cfc2a7f96519ffae0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d01658f376ff721fa57e079f7ebf1ea77bd9e8d4eef47c9e29143c8c7f3d4ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "524349f51b3f0db2fe0ab4e30a4cf0a69116213a0d37a4adaf6c811ffb1d631d"
    sha256 cellar: :any_skip_relocation, monterey:       "025c0e2cd0e211e77b05bed30d570154f9a40985255c88208205e932259237c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c3e81b8d266e5d464455c071e11177a5bd6b80a3c1e6517f6ebba4ea85611a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288d077ba694a085a7d4a975d0318b5f4755bb30d5930e0bca2c6e3a6ab558b7"
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