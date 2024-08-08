class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.533.tar.gz"
  sha256 "3b9fb2156ef24cf9cf0ac3def47137419ab5b6d63edec72f8ebb9151a83b6a6e"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51e5b879e0ad535e4f0859ee2c8b0228252b3ab623fd3e2552d7d534ccc99d40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c7f35defea069c633cd462c3dcdba43313ef4e143a424c1be3aa3725c08da72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b61f31aeeb52c6617b2f15a5e118baf952b0d6ef50c20fdbbb9e7c0d3a68161a"
    sha256 cellar: :any_skip_relocation, sonoma:         "708d909b9316bd69581b66de4451d49e809608ecd0dc1c3a510c68efe9df5fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "20e388fabe965b7e5aaf203750544c5b54e08ef1c0eea09a7713ee52acd12939"
    sha256 cellar: :any_skip_relocation, monterey:       "347ddabea2fbe8cf175d15c27239772967361732f76ab98ff7d3795ae377c0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1b230aa696ede63053f494ba7511bc858e0103b60fc9c564ec75ac2f02e0f9"
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