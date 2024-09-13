class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.544.tar.gz"
  sha256 "edd4207bed48bab3527737fd8d2f45acf4c7e37724d289310dc6547ef42051a3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1da458630bf86d91533b51564a5e22c29da9dc3771a414230301dab21c15adc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d473af8b828080832d3a3e81ed9dff80ccbc314da1bd71e094e6a281f9a9884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8072951c3b5a41a36bf850780554f69db78e0fc010158a9d6f31e16567615dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ccb677e2650f2789b728d551c4e234d14eb09b5b1415a9d255033765bed534"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d06efb3a7ef8bb0d1f56f8493812847de2c79915113c55d7ce5d5fb32bbe663"
    sha256 cellar: :any_skip_relocation, ventura:        "43a5a06c28720156abba948492c56a30d1a94d62aec350cbf914b12eb22791f4"
    sha256 cellar: :any_skip_relocation, monterey:       "73981569685bb9724f36472226164e36f77edb40d6ae62d97b8ec32e2ad02272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47bdce173cdb1bac09d0980c763eab929e0dd207d4e86061d3df0b2174d90ea4"
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