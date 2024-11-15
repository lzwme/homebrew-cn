class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.557.tar.gz"
  sha256 "8054295ed0b9a551b51f7e66e66feef1305da075e0098362b4c4f874ebeacaea"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf991c9fd31d8b6e0507d6f3d35a364ef0708dda844b3410b78fec4def8a0a8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aef4cf9dd15b90a3cfd9cccfc75d46b9d1ca07cd8e1242099e5daf7ed3c9c9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae270b33c2cba5148c4010a9170f0b547e7cf4bfea3e4290e22c4d2fcd2c89f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1223bca85ff5af96d534d2aaa106152bbaca00ed6eed7cff71d3e1bd64fa5c"
    sha256 cellar: :any_skip_relocation, ventura:       "ff4c5985ea9854f8a3658cd46934ccf7f8642fd62995586744c85f3972283b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb8733c9d36c318fc8eb357c540a759ff7ed0c2e0268b37cb65aa9875663909"
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