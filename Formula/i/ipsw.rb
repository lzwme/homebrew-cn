class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.566.tar.gz"
  sha256 "75195ee0ce22aa398ec762f34ae2e800fe7ced1425be703961eeba4d3ef1f395"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cfc073fa228eb283ed5e4e15f3967b6c68648688265216e514b93854019a00d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b5b4042b6646c7f30bffc111d1bc05273dd040234bcaaca75d2260ca461bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9980f00cd2b94dcf1608544eee1bbde9358cefbc988f7cc8e7ff527c7756c62f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a394edbb2b20579951803a1d744389aa4196dde79b52e1a92668bc03d8e1c8ab"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5cd195f850ce488e94f731b42cd64afb89c877858819005cb52a43040a6bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd33db78da81e8fb6e60ec6e606b92d8065c2d8838c8b0689e45f14c56becdc8"
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