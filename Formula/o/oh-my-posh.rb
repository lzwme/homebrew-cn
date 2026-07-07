class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.21.0.tar.gz"
  sha256 "ea498aeeb4fcf331c6de7f48c53b8544b4a744e71f34d58d50c7ecf6685ab252"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e389559af55936b63f907b5e9f2e0ddff895844e3ee624219e56ea80718b5f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc67a139fec3c8745e293cbfd341fa5afe8668e9e12c209541706492f27023d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3773babfe63a5848752cc0aec6ef84603527e5eb7f47d36b34c46a58e7befe0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "526bd347409d226c71d7cf4fb2b0c95c0a47ec8dd331dc1b1b6ae62a779f95e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ebd00af121b764fa70508f978e5600267adeb3228760f39b9489cb23dfef339"
    sha256 cellar: :any,                 x86_64_linux:  "9ec2fd210099d49800f8533fc9feb4c5bd11d3218d8fbd367671357bf49efe29"
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