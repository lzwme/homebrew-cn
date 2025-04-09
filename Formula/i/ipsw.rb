class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.592.tar.gz"
  sha256 "be8c830dac527e7ea249638775b5c68e80c485f0d1fd1caae603922f56ca0d49"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9954b732094bb19c5bde89efceacfc9e067ec89a566f3665a78500b0f8cbab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973f240d86d29a81383dc26f641181c945af005330067f893f43e1533d1a1706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4df3c8be5dafd6bcf550c5e8270ce612c9b9e07d560cbf5d3d4220e064e5434f"
    sha256 cellar: :any_skip_relocation, sonoma:        "360b1fa014c06946b59b5ec5e75ed198c45ec79cc8c575fabdea753b17c68097"
    sha256 cellar: :any_skip_relocation, ventura:       "f7984341816d96e1ed9d833503bdb912d58edd79ac4fc4d21504a9316725772a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41609a7916e35092620989be615a71639641c4b07f16ec143948dbd15ae4c42"
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