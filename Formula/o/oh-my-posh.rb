class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.27.0.tar.gz"
  sha256 "3d8112dec1fb0afdfef866dee435096216a7244f0f43ed2a551621c87ab357b3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3667627303c53a2b042dd455577c4aaeefb62b08c45c6f1576d2f6d21ffa7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864602bd2f3d6b48aa0234d36a81fea7687aa819c3f5b5f4a896b2e25795af03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38247714481c93608f0cff475c2d6ce7d57824c3680a2e46e68557380df6bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19b613839825cb052a7bc1ad219c91dab3f654cc2f95466352f471ee2ad5bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "621ea69613081a048587bd2119452259ed7cc2586bce4137b5294944bb62934d"
    sha256 cellar: :any,                 x86_64_linux:  "83ae011c373054b8a4fab3b2720669bd84d6666baf06af601643df75fe880c7f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end