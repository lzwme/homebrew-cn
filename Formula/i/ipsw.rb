class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.555.tar.gz"
  sha256 "0fd4b995cc34bb243291dad01cf9e015489de978f40e3a3c8cc02261afee896e"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "930071e5c0dc46104e611986786c7f08edd2bc5841b0d1b3d119a1f5a7fd9c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdbd75dcd3ecddbfdeaf73c1f271b4d8960ee2908c23f75d35a7cbc827963bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2b6e89afd7f6ecc650a43d28e2497cfc55af88d83cfa673efc6d8f730235649"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d5d84396266b8766df634effce242e90311b8cb302a75219750f113fa3883ee"
    sha256 cellar: :any_skip_relocation, ventura:       "596e7f30448f164bbba5339d6ad86b1d3c2fe41bc1ded52458e13016caed04d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90623695deea690eb2fdf0454fce9ca7439712c3dbbf151a174525560ab05c7"
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