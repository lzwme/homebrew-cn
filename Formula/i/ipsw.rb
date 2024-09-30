class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.548.tar.gz"
  sha256 "bc645f91ecf0a2542100a98b5c2e174cfa795455db9a1c288958fefba11c4d32"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4214db5ff0c68e9b9701f7a86b41604ad3f2890926c1e149bd8056ed876943cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cb192b30b928a96ed005aab3168642d1cd62625837de0da085cfdca2c8cba7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d4d012aa54d5f6af41599afd2e098747b9a77336c8230243d4828c12f039198"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e344b5b9b1e8c0fa23d75dc36121a7e5b0dcacdfa889dc42b6542682cbe13d8"
    sha256 cellar: :any_skip_relocation, ventura:       "c25cf9c9d57f2c3ae4f85668f48901000583a9b4bb11a27f4482b209dfd86e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5cc4e8324910ac14739963e7fc8a9a32e6437a10c50f18f3598b186f414e136"
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