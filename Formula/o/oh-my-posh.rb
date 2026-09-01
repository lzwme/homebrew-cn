class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.1.1.tar.gz"
  sha256 "c4d34b792192435cfdbc4fc05955f44f45b5d84fdde26b7553af7e07112fec29"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e0ad662ef02e6e1ac1ab74407fa3fc885e4e539b7de2ec6606eeecf2bd175da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a333a7c53147019c442310b1f597093b066c05528c35dcf2377e359b2cdb2449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b396dfc94b84870236e40b8599197bf83f0eb5a68d649494bb05f1e53e5e74cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20f535b03cd79c1417be15540b35277433dd0fff41e88e416fb2c9adb875c64"
    sha256 cellar: :any,                 x86_64_linux:  "7f592881db88ae60f8a12437f899e10ee63511a12b3193eff23450cc73b8c1e6"
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