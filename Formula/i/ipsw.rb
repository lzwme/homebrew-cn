class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.558.tar.gz"
  sha256 "0c1561edc0b83cb11924d8cc2212c68a27034b98e195ea6fa84b69c703796a8b"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b31df6bb5bf9151a6bfb37cebe78359971e87b0c142ab69caa5ac455dbbb26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f824ef72e8da8c45f067caf907c50b24126731555cfa8b3d898e42e15b61758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a45bf4aa7110f3741719d1dcfa37d64fe9487e33c55eb9a9ccf1945018649d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc56451cf9279ba82d2bd64feaadd515b7e4c14a38be4b5addfc57fd8abb71dc"
    sha256 cellar: :any_skip_relocation, ventura:       "b31fb76e3da6c39b14f29acbb435d96833522cb7af75cd3a9eabdeda8e948625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b21d6afec03cf9440b0d86e78e18c404a1f9e0f6e3f25008a7da3c6c62877dbc"
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