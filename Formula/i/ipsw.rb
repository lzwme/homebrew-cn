class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.584.tar.gz"
  sha256 "e9b539bed451ad08a40129cd4cd27c1e47de0af49790bcd84dc3c4c0f08d65f3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329bc196ac502a40698964203b553f857c6c3cf25dd5c3f764a2da6fa6b0f6c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a433568b5e228ac249d7a46aa6e249cb96ef9b0447801cfdac0e88751c362ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3ea23ce12e4a364e7f95cbe6d2335be7d6e9ad33c81dcd2df64a9237b476e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "62689bacfa3e66f13705a23f50855eccc2fea07887327c3abd335811d0e409aa"
    sha256 cellar: :any_skip_relocation, ventura:       "50538d916e394cd47dffc9b595732e4e3e422d4498eccfdff6d8e06b01969f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e8743b49328bae6399275687caf593b6293dd4580754d7f3b01905e0522c7b"
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