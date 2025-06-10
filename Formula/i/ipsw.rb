class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.610.tar.gz"
  sha256 "f3fddea8b1af97265410dda0920b1ebcc179be0bbfc89b2e833b0f4292b89306"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7995c7c7e41a30e7d02ddecd9cce226851f627a23ed51481392950752384e5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d59b0d7711c913f1756da95223d7592a26cd449e606a7ad88bf00a592943141"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f449bc82fba6264cbd344047caaf545458ae0db6d1a4fafc42de37b5b01efaf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3bfddcef2c59c6dbf242a5fa5d91871fe34185a6e498c17003b3511722b9b52"
    sha256 cellar: :any_skip_relocation, ventura:       "e4140f4a466f7d9b478915223554386a54f9cc21d9d2099e213545f651d335bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178e5c53ac2c0c14e4bd1c4fc162a7687a371c8429adfb9b2ac9d19eddbfe77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "115920c17808c5f5341118bb3172433f7a70e65a451017d9aeb31523d75d11ed"
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