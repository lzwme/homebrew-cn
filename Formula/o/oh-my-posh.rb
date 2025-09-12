class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.2.tar.gz"
  sha256 "74aa7077cc9a776f200632dd71bde89a60b54ba33ee30ece191a6569f111c8ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db1622c433c0405d53514fa8af3c95133e7d1057d5c9e6b40151b30e5990d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1189955cc582ea9b0ca4a7c34fbe0b2eaf178fa16baa8f878108485e6a9e79f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9cbe722dd0087a073dc80ff93be44d29aaef1304dce36d864b4db324c35595f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfdf1feb21866b00427f673db97438b92b0301b7152e06865efc802edae4e9f2"
    sha256 cellar: :any_skip_relocation, ventura:       "295a6a6e956d122d6f6f068d1af5904fb381e15372e7d4ab95dba5f4a4300210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e596a7b12db3aea783dd1fcf1bdfc4779a4bb914d444220cd07b85742182bbd"
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