class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.538.tar.gz"
  sha256 "41fd25fd8ef77d38a3c60204aad35f6124001c3b718f28d9f30c0ca9f0882450"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c555e1d826b67d601e92b081791712561d93f10b7c347b1525bc6d55324ef93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eef69611be05e3b70e5f17711c83701d683f43102b048e12e8d79233f94bc93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531ca7c19dc27c9a37e6533e5f5f1261c950d0b147274fa324418036079cf069"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d069ae1a180035d5c676bc1d263ea480741b9e79440e68814f8af7fefe35766"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ff7cf57a13349ca5d08c4cae9560627617a722813ea41b76777cbaa7f28d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "381e3e65b542e392ce8704a5b80e0240a5486606c0ce89899bdfabae386711c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016a79317c36a729ffa55d5e3f788ccb601ea1aeacd76597fd17cf9759a9acb0"
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