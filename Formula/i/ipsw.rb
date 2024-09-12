class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.543.tar.gz"
  sha256 "6614e456f2d91a2243cc79c29b7d0e631adf93a053ea5f28a42ffe0370d34d86"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57d417ce023fc77276f6b9373ffa2789c984e836cfc580acaaaa998365640ee7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3de5666c3c80d3d8e091b230d83b0b327b04e4fd97e4b3b03e5c2637dc8c7ebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3bac54b022591d877e3163718fe5fed35afc380930a529c737b700c586a1296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "505ac621970dc7b535c047570d7c5ad47e5fcd8b370f11568c1243ae49c6d72f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e77051a20a34192bd8fa02a72dd829b001730fc2bae828517fd05bd1ae47a695"
    sha256 cellar: :any_skip_relocation, ventura:        "986939d5441f1ecdbd4f3b928fe6f35797e3b88ff34cfd8462a4047532936c13"
    sha256 cellar: :any_skip_relocation, monterey:       "32106f3f4f77a9ad0099143349fbf2a7c07da0aa78dac25a39b9619b11123308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd556b9e2e8a6a327ce0d239afb7f72a921946ea2e29eddc3cbcab619805b4d5"
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