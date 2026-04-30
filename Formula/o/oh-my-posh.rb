class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.12.0.tar.gz"
  sha256 "9cb8cf3b69ce303c3d956409d028fb171642fecfd50655562cb9df97d038896d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92942663eb4e3cd9d36b3e191ef98eb7f1218e6efb132f703e21f48d91bc745e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5134bb8a2edc6102f594dfe66eee9bf642daa5776c33c9f4baf1e737dc093a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f1a2e03f412abeeea39a3abf3da7d8e2aeacc2fe9706e34c65ef3bcea5fcec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b1536be99ae8731a8ae5c88a264d35918782f6de389d3999355c6fd8769686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a087c724d3ed6d4918e6362ad323666761ec519c3a87067f30474de2d7c4fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29888dd162088183c90d85c4cdc396cf03101c30d27ad25ad81a59f74ba4c100"
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