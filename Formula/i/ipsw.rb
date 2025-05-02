class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.597.tar.gz"
  sha256 "c6bd4f7935d54a778a90b6e8455be1baa4f5ef1f5186683829d4a57b8f4c90e6"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3022e37d77e6a1217ad36ed2904b937a7310f24cb10ac033ee1fc07aa0be55c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72427a13f8407756b5caad56582b499c4d008c328f25872950945c2d20ce8246"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6781c0bdbec984dd3af25c1ae9abf876e7fbb342eef10ea02c4be56239b986c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ba9d704058f6102bf933d425621ae381e94846898d9d6976bba0ec6967f8cc"
    sha256 cellar: :any_skip_relocation, ventura:       "61be652a24a2743376658f4c178871a1d8acc235d108d1b5084e7b844e106e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ae8240222bc7aa6d6f41a7f46529701bf65bd718aad226a2e3072680ffc5465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c9c6d901fcc0fc820d1387afc6d1ff54268f9710c2eb008f05efa8fa2882e0"
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