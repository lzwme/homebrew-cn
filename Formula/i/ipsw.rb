class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.601.tar.gz"
  sha256 "8b4868b9434b8c88c076b85e5ad045c5bc3fc390b6af30024173e62fbd54737c"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c116b6d19d5aaae3d3ad5744760f61bf24b5cc650b902ac9ba14ad4121b3bf72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66fa353d660f75c52f121b87ad125cf5e3e2336fa5c7e029e3b5c4ea03921c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5640c9924d192670d7be3a1b8d084a7b33d49343c9f166e7bcdc0923267c4ac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d384cf61deec1bbbd8ea3e0ae24c8a6c3177eb5986a334eed2e7afab7b529d78"
    sha256 cellar: :any_skip_relocation, ventura:       "1c4641c98a4642570ed8fcf147a2dad6742c177b65b01404aba6c5292af46a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611b79a9bb2b7457495fa039816091cc0da5f115748eb0e6252c0807d4f7962e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d27fa3ce373e471c9a0d38ec33ef6057bfae0854e4bf5147e03f50fa226a03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end