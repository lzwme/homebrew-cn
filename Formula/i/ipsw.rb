class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.587.tar.gz"
  sha256 "ff554149f9a696b04c7668c3c06343428e3b4649f4d02a1633804e55a668d6b0"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d471b09f2ab18eb16bf23815eb2bec08e0d9d2b6ed6d17df75ca568e68d580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00c076d1c3b70b69b25f179e9b7ebf018685bc2f7a995fec652c6f66ca3a36d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad1ec704111b024eb0fb7da8db359b9cdf6d4e435a287c1a2746d55467ab8de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "427016cfb520d0a755865f5ad2fac750b47c72fc4b62a3a19f0ba59a5284176e"
    sha256 cellar: :any_skip_relocation, ventura:       "b2bc7ad364f321826e35f3ae66201ff942a1d7d3e0f58d4865f747bb7debc80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0125e10d62e8364a94715331b3de0f5249e7165d4910d273bd010a0be97a41e9"
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