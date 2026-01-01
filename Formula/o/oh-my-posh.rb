class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.9.0.tar.gz"
  sha256 "4b15555fa62fad4a025300f96200a1ef112a0dff2c22fcf21b0fc72486652e4c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0160c4e25079882eb130f4759f789442c86e1947211074df23dd8bbeffa758f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d93a8fdc90947f37a849c875a082576062beeae8743445fd53c4e210db729d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ed937b020e26bffb2d8cb83cd083cb0d64dc7713c8f6f0a5e9179f387afa9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1443f08ff72cc5d5a84e0c40785d24ad9bc8ac8eb0493990e7d3d1efd58754ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aaaa94bdfdf0448290266959f08bd3cfc6ac1eb655dcf92914a8da49b50f15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b13c0c6d70b6d91d0043325dd03e5aba56ef61731c9786796a7b7395002a9bb"
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