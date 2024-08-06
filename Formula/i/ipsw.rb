class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.532.tar.gz"
  sha256 "3e2c313c82615f7c3a2014572c136ef710b807d288a76d56dae794d17f4ee096"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff95cd557edd54639259d48a5e321d3d6a67204802c21772456deee365ef0a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5ca232c19216c26ba2ed639999028c3cbe4426c308de3c3bf62cc039d6d0112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e6afd0bad339834662e5d71b646335337f3d20c22f213b4bc958fa055e4db4"
    sha256 cellar: :any_skip_relocation, sonoma:         "df8400e79c03a2bb3eac74f806cf7e70e3161dc0c2f7dbbec908ff28973b39eb"
    sha256 cellar: :any_skip_relocation, ventura:        "05eb7c06ade4efc065b7c80be7dd08c10b1dbe212bb0b85b4e707578de4e8f52"
    sha256 cellar: :any_skip_relocation, monterey:       "e5b4ac8f8be344291a22e774269c36e7f2aa0b0ccc30e4bcaf6627a5f490d9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d795cf13864f9e7b8a83079357a36d0976db73b1648bb37b2a98cd58e30cfeac"
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