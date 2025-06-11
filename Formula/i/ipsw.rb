class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.611.tar.gz"
  sha256 "968397253f8d7d55a748454cde567da083dc8678d8824b2788e2407fcbb36b32"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb75dfe830d9b35cd84a7722d4bb87f37c3a517cf4914031b00f2b38e950c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302e7d0f6e7ee44ce440323b0748c685187b3087e410f3dc75f8eb0705a39b64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bcc7fe36c610c56c773e429a029285a2701a192c8e15691714b5bd4393c83e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ea819050f6901c6e6c088e6191f471328fb40809bb91a41ab22df85606d3f2"
    sha256 cellar: :any_skip_relocation, ventura:       "da70806b4866dfcbc3d52bdfd95073ced50670ea47c04f0ff51474a0138d95b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "506a45fae2472379527292eea3c16aa8a84f71b2cf41fbb90a35f8bf97714cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8e0d5c9eae590495b38b4fd5e76d87836893ea8795b0f85c836082c85af8fc"
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