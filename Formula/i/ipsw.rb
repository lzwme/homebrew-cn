class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.560.tar.gz"
  sha256 "940c2373238ce511c38311ed2f700d91e56f7fa338f208310941a5b26b894c61"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244748e43ae91d75f94968f28200dd816ad44baa4d99511505b729c3a2069ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66735c710fc5582c1ad2fedade7a29703cb468fa746464bd8bfa04620d07ca9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "110cfb2d6383a41c8b1098a4f1d204e7277851558ed0bb1a34bdfc2752bc20c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3055e62df46a61c1b172bc458b49561838964d1a8e8eb6748a763d65d91dcb"
    sha256 cellar: :any_skip_relocation, ventura:       "1cc6a5b7178bb954044738242bad8a681dbefce1bc391e663c75cf3ddfa1a47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c39f43c6c2f0987025892fb43e51ca9668c93bc9841f7841b61281e55f85229"
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