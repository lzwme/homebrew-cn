class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.547.tar.gz"
  sha256 "48abc9548885bdb78e4f85a6e36ddc6155e89a2addccb74d285bb43db09f2e83"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "774fb6040a53bc32cc33be1b7a1f9ffa5a6c1cfd2d7a2bf1c32e9e71e353c7d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb28ac4c7bb8fa7b3e33bfc665623f745c8d5c2d7aada77b2f29dd0f2e538d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53143bda60e7dee89a0df61a0ce2e0524f1239ecf5b7c1ff21e813ffd98f38e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbad60a28495d379272af6b55343391d3ed27c5c7610b8ff05fc73f1ea48e658"
    sha256 cellar: :any_skip_relocation, ventura:       "0d1c95b82c9c0194a7623518d00cc4d59c48d0e60340fffc7ec5c1101c5bd076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fa948afd9ac4abb03a64e74a11e8b5749973e23ef867a396bca3044ef18cb1"
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