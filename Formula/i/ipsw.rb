class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.604.tar.gz"
  sha256 "7d20d551d9a69db55ef7184e66e3cd08632096ce44f55452d3914f9fc1f6d8f3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bfa41e3939d79e8a31e45c345f8ba33ef78be46e317a242176a5e818b9b41a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ba79d66478dc6a9fa9a06dee2e6dfb9086faea55ec141952da7329984ba7bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5922420af0742ff04b0f5c40022c2ede98e7780f6bb2a02f68a7fd1719a9d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "c37f566a6a07379e7d6b346b5d5f95000d1e6abd2063f81922f97fd2d9e55142"
    sha256 cellar: :any_skip_relocation, ventura:       "8af10aa0d27a1ef965c9ef85c718fa867f24370074880d4caa0928814c4d7726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781b70038a6d2fbea06c707b5b6ef77af455a20a528e039de7ba79fc4ac8278d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208444079d04d6367ea3221afe62a97e520d3fcab63bc568c6522113abdd8120"
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