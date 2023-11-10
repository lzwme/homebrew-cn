class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.25.0.tar.gz"
  sha256 "106388473c8dc627bbee53a5b5f42c1b3792e85d0b491ba5a18ced45c3b52aa0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d13891c7f5a7396bf70eeffd1bd1fb62e72b7cb3e93a74a7be03dea5115d78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499280b292565da1e967e80b1f9456ff5d63c2a26267e3af53a84a6168a0e9f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77395d252d70e6fd14aa38c9611b7806ccc32638cb35372e842a5f6c46d9d511"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f73c061ab9ed4b554201cb12944bc9c8c3ddfd6d2cfe8723c299c286be30978"
    sha256 cellar: :any_skip_relocation, ventura:        "a211f88deb28020915238634493c965b7ec06ad097de25caedbc4c785c306293"
    sha256 cellar: :any_skip_relocation, monterey:       "837694b9915c2ad44930012744e0e7e3ed8950a2c9ddd22472eb10bd745de588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ed8d046cd4566e5ad7e692f714a9be92492a6d31b0064f42a26994bdaf8399"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end