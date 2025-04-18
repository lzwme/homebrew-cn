class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.594.tar.gz"
  sha256 "c2878fed49eb9d3c5d4a08ff0b5afa8fc39b364e8365d91d925124ddda616747"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "751c883d35e5a95be20e52df284af308b1b2dd7cf570f324ef2ad54406557e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f24308283cc79159da0458190d3a2115ed20a05fae44920345eda485eb8826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a53c47b3cd271697ec528da5c9e25be49f9dfc060396b7dd8e0d4293061e15af"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb90fc566d98eeb4be0ab6328bc1740788878a2e7a30b4078f3fda8680267a5"
    sha256 cellar: :any_skip_relocation, ventura:       "1504f0f459c276c3dfb56bc3ca423d3c6932cd559bd2c40a1043d540bfb3a106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209aca2cf7b23a619d568ea231d9c70af75e9817f6ba90df4b7c6c55ba6af8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238389ab336277979dd4c47ea55c041dbc83f472a02dfed05eec370c9caab4a5"
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