class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.556.tar.gz"
  sha256 "1f0cffa28ff50467e20dcdef0620c9a7c48ccfe73bdf86ae1d86fc4c7fc7a10c"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7b204072d8792e7ea7e613baacacde03b7d5b2cc1b18fcc90cbe2e444e6b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ae13e35a423f7014aae134ad6860dd2f6ea2d09fc87c69f66e60bc66248e38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ad65b634afaddbb4ebe31c364f06ebf64c704bc3ec9c2008ff562336b288404"
    sha256 cellar: :any_skip_relocation, sonoma:        "d847ee9526f8627bd534a78aa36b65f3fe896bb9a55d1eb3bec3f0f08821b9de"
    sha256 cellar: :any_skip_relocation, ventura:       "13cdd53948f97eb519146b625ba4228cba19f5036baa2db816a45d212f3810c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c3115a15a5aed833168fe871e3ad50e30c364bbf98f134ea20478c2c5b13e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end