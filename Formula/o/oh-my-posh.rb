class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.4.0.tar.gz"
  sha256 "239bc9d19e38405e03bb8da8b9b9d09f445882912aed1552b9620ac383da0efa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "119510c10628782ee6114c471a2687bc60f09f4ad187982cea4b337d4500e358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f3f143af05aaf6886d4b801bb6fd156c6769b577c8a9f5e64022949a0cd02b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450074b6f72f68c0c7a608dd3c2d9c54f19cb9ab6f2bb8bbf32452a256a22eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1f491940763b98c833a70e072a57bc3d86f2f16b7c1e393471a52440b60987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5884cb0cfc691781c8267d6c16437e40a12f4b807ad2f49f570869c1ed990c6c"
    sha256 cellar: :any,                 x86_64_linux:  "96fee45203271ea82782fac14c5eadfd8b0058227ef01854cbfb05c6df8b137f"
  end

  depends_on "go" => :build

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