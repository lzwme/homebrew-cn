class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.569.tar.gz"
  sha256 "c02995772b0982cfefa641c333f7735736d82ebd689acbf2304b95bb2844052d"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce6c6f87427374ba92ff3ecba8162f0e8d6f758d1012ad31991c2f80fdf08f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3370ac978c0655da89d445b809fc0e2dcbe32c66c842097f19baad5bde21298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "144a2ac135dd0e91d4443c3480624bb3605bcb6e3300fb3806636fa408865f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71222119792467d019aae9514e4ef08c287626cdd508f06099482c44db5bd69"
    sha256 cellar: :any_skip_relocation, ventura:       "a83be2e23d351978bbf44ca5826c3f7771fda71fbcf0cf40e4a007b5aee6793d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7d11cea4b8f2b512ee60b5383d450ff38d20a73c1bb599ca09f173a5c08314"
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