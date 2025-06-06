class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.609.tar.gz"
  sha256 "863d1f2b627adcb77a8fdc55a5a740865a2ac7f90a1a2e3571977c4b00ac7327"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908ba6fab1c1244c413d99a6dcf41c3bab705d2ebeffe20b970566b8355488db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4517125149b11e27246616a7172ccc5820959293a04dab4314d6b6fea1c35538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12620733b5055df3f384a633bc6d69205b852a81ba67a9aaaadb62cbf892cc3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "548bb917421616d2ff470e07782fa37e8092af5abbb7ceebec8992d0ed263a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "7114f4163419df61c3f44f35df2658cc12a1110706e49695c75b1864b4eec8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c1da7a3259c7dbfbcabf7d14cd5d242dca63ed357f02f58570062dbd06de43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5f868c34cadff5cfca2dec0b6920e29719327873c9e684e709d0daaaa766b9"
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