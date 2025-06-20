class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.616.tar.gz"
  sha256 "9d79fa220ecc91b08d4d6ee169c175a7a3d9de0b2056ab0efc45de9be0c0991f"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fcd592a9b0c104d32fdb433a3b8e595c659b83239175ef3784786704de518f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18cd72609019eb0a3518b959d7a2f554651d19f07ada26ffdee44ccf18be32cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d2096d40b48f42bb7aca7736a74bf91edbc1e54af750df743bc98c4b4c14380"
    sha256 cellar: :any_skip_relocation, sonoma:        "e87999dc5829b7180cafd35e81e2120c410f893dba733b2c6730be4b0accd695"
    sha256 cellar: :any_skip_relocation, ventura:       "639b7f0aaaec6b696ae63d1d62fa01af02e5a005ab94257d9ca0031f91130315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c9832e92f0f228aabdae83d3c4b3f08e6151bee7ab23f3f77531a8a4b1eaa53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4291bc35b8321c2e16828ee11650d8a936098e8ac95905e2b545fb7211a68dfe"
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