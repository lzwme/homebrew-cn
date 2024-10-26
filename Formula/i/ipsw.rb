class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.554.tar.gz"
  sha256 "6f7ef50bbb0627687fd662bc5afe4a3e66365b7c952c3a8c0cf5ecccee6f62a8"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2862d75741c3cf926f2a04d98d08bd33f5bc740436b3651b60653d587fd41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5897e7997bda1d5e4894084eb8654a81e54b960cf0ec977992b04df538b19e07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e3e2ff698afbb589da46dfbf7744528789d4792ce8982bc06ebef989212abae"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cca4637a19543dec80809c510ac1880476296ecbb831558ef0bab87e4370ca0"
    sha256 cellar: :any_skip_relocation, ventura:       "1327ea01e78a5032fe661b87acadbfca205c3be6a47c28bd88add16889200e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2644773908010c893ef45017bcd1303ad190b82ace23246f5da44d6475568452"
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