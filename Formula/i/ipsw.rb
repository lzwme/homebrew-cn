class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.586.tar.gz"
  sha256 "754ac406fc1673ec56b722af8992bb392ea0a168f0409d6147a7680fa16be3d4"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9afd8f59a3d62d90990a38f60b95c537b43e521af51c4a1a3e62d3013c4a217d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5540c5d676793d42a7ca97f5b0a2d0e57af7bbb460bfa6825095c4bc1fbab4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb3c89f77a7a97f68a6bc57e033e2d66e6aca0279aebe913d74c694819755ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "201ebccf67f6a7579f8d6566d6e0cb8d8829667e1b33ec1e27b44d6f0f0f46f8"
    sha256 cellar: :any_skip_relocation, ventura:       "8eb39e0f59650d99e13c85d82399d1cc35435cc2371fe1f8526a90d41f853303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95626e9a56dec95f5e3425a9264d92636083f74eb51755d30f613f9d87d21b9e"
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