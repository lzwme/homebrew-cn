class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.17.0.tar.gz"
  sha256 "824f0f2a5746d73f2c964173cc03e24283c38415e3f7d25ef71f4bc7b84073f0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ec50fc531a56b2d8e610407c0b9bbf9f2af11a9d4295ff3d4e53a10293ed01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d2b3d57b526b115d28b8aab69bcab4d0c11bdb7389c10bf714b1acd9750423"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89182e9055858ba68a39fe60f843d0d9e51d0ef17a015964522de7ebc2d71cdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6918b8fdd23ccf280287b13180213c550dc4b52dab762814fc05d4529c637a4d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ddb18c87888c685b8eab3c1126190d3144fd0eb22755188d50173c486381ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490c3df979265278e03dd3f5dc8817a8e0b40fe128caade455b07eaeff4af0f2"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end