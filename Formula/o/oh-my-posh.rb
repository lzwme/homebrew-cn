class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.5.0.tar.gz"
  sha256 "7278074d81902b5bc218e2476dd0952c4ca64ec2f27a0b5f4d7c6f4b34fed6f7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05561d4d2836993ca9bc4ca9dc84a5c68bdbe63812a31c89b0f4ced23a0fa63e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9580f2bdc498b5192ef8ec283fb4916c1a18ae4b800e2e54a0cd9135279735e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d64ebd39388b3b27e1beedeea7d4a609220861de1aefeddc43419d923c11c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd850495fd775d672d7c3e2fef72f13672807e21d2283f32b88c053c1bbf87aa"
    sha256 cellar: :any,                 x86_64_linux:      "dd142f8d99f2b2f4ca0307e77bf17f2827fdf6dccaf726e6df04c29f41809144"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
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