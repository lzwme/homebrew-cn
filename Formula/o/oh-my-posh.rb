class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.5.tar.gz"
  sha256 "de73048efb1a54d7ebe9bff05a624fe792652c4929ebb342f201863a8104b8ef"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f5b3bd7d356f5cb6dfbc8ba10dc7b508c5965dd51c7d9926b4130423df4f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e70f3338f9895ea440083b4b1e02d6aeb017348430cc92ff13229e63ed3f688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b284d7987ca149f00f9cf45b5a005b17f52a67e7a75ea2a83f32abedeeca873"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a10a49d40ca539f5c118d88ef2b98827f88483e829f7342183f9ace69caf058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5545dab8c1c9b322cff9b7c97fabab25ec32a01d3b1c3182e101710d2fdf2779"
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