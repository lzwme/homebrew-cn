class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.583.tar.gz"
  sha256 "022be955c1b7aaa403ef9635b7acc4a925358904018e5cd3c385adf2f4f6d52e"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1fd76b9365412297f431ee0fd320a44527febe84546ee0877dae11672ad3d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e72d848a9361214e0bf9709fed04db694c9fa9bda90bcc04d436d08795bfe31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b27f5e904fa24447a2841dfbeed6bfe227f93c9622d30a6c7308dfc8d782f5b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3f041da5ea94557d5be8a06e8eceefe9f230f5fabff1f5552d4131531c17476"
    sha256 cellar: :any_skip_relocation, ventura:       "93d4a13a7ee9a95acfb0664d6b61175f2a0aa1cdb60a2860e0a4fd7782718879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0297997c95168023cad7f5d21d967a737432cea40ad07e25042fe8073ef7a930"
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