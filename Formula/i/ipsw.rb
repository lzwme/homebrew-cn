class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.534.tar.gz"
  sha256 "e0b5a4145d9e952593fdc6b008ef3a7e3295f5cc4d4053746a81a952864ee890"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4443aace0c810a9f8f7d948f3de67ea83da038cfd2185cffcd592ab81e603938"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcccced82a05a9201011ecb893d800a79054aba0d5eed32e049b181ce46d1a44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f37513aa247fb50886dd40e2f0ccb2a451c2668576629a0d20f89aeb3e59986"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eff2fa59edffb1c217f9eddf3fef1d209603a5bea9a649d0aa9b4dc8dc724fb"
    sha256 cellar: :any_skip_relocation, ventura:        "55116a3db2e8bae104e4e08ec86c019e035642dc82398bed13bdc0a1d52527d8"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ede3c8e30d97b9c9d62602f4e5e3dbe5b66d6f9048a72de0e33f569e253d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475b42406f25df6465980e595b5a2307109b1202de483c38797e6d1ca9032463"
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