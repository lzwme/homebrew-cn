class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.537.tar.gz"
  sha256 "ff2b5788171fc10045277b33218dfb02b1307aec070580287e02767c92470d0d"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbeb68795367e4f5eb533c9c71dae770160777bfa5d24e675bcc450d2ee95a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d515d85f166dd92aebf8ce8be8f19d0e60b2f4bf23b14c0d031a93c9e00ab504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e06d3ea1707838b69cb19b27ea381637f65202367023aca4912e25a367cba1"
    sha256 cellar: :any_skip_relocation, sonoma:         "15247d3d7e474d7a354ac9aa018f7d7e5e3e3e51b5c5466955bc9685f4a3a265"
    sha256 cellar: :any_skip_relocation, ventura:        "796821bda1759e0315662a0c23be8e10f85368e767c70042be6680404447ca15"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8170545f87b0f47aaacd6c4366413b195b047fabfa48d249fe2e0e58c65b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dae8cd721656b5c5c7a09cf9d7e7f172b75e793a1bc8bdcb97282d7223b6212"
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