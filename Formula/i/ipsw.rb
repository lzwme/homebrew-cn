class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.619.tar.gz"
  sha256 "22a49ae35d7094308086613f7be861912f3ac0468daab578f54f13c05adfa5db"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50321526efb6443915efe2c576a9d26a05f78faa200e45ea469c51b4e1b738a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd926f2a35425a808fc84f4790df495f9e3c2f85ea4e0f80d4815dcf3274638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d84aabc561c0bc95e6e137489a625890136e023e3a1f0ea681a7098d6adabad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8da49e14afeabd6350aebb835e8d4e8970d6163e99fb4bedcbdc071ddcc5980"
    sha256 cellar: :any_skip_relocation, ventura:       "2f8d9133a7fe4ef1cd185ab19990da5e8c4765920954a3235fd9cce60e65783f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa3bd88adb3d1b0b495dcbfb7a837c66bbc5931908364df0aa2fae194599f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee5d28c2796828ccece9b702d268d82d4b99e801d92b3a56c3b7245c24edb6d"
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