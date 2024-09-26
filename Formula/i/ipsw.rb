class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.546.tar.gz"
  sha256 "75e1942b9e6659a60d0ec938f93bf00d3d2bd92719c0d1b4897f2360e1c652a3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9d6b107151501c05aca630788cef9c435f2d4ebeff964ea5460e8b608a8f24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd762c9343d65876a02a4d308db404f3f0b27285bbf71b2af5055fe4d0e66675"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f019871ea62ce0a1aa100b0d13678902c838d4d3be453cdc8f31688e4df1ca1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a73db9e7558380abede45f3704e2a85f4bded336f9a20c095a2321da05068e"
    sha256 cellar: :any_skip_relocation, ventura:       "84a669aea54656a6112b4cdca2930a75521695dbad65d4948f518c75d36f3f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef5dc27899b9815a8208cd95cf96a6572d91e5b99e889b943bdc8faef49e69b"
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