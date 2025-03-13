class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.582.tar.gz"
  sha256 "bbab1dc622abc40029831e098450b555a3d819af8c4d5b144c5e7f0e44010e1c"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5d56056d618d48df67b0a386d0c1b3290d5b6cdc590e17690a121e88dc5434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fa742b9f1edfeaf4ca9757349938faaf64073a42ebc25525bf5d72bdd67644a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ab2b3e91ec112e2dbf4cc6ee08ec1b534169403dd07f53c73673a72a9fd4dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "3984e2c9a9ae460f2c3719603a11a9a0a139ab301e914e7e9d76cfa40e44bf7b"
    sha256 cellar: :any_skip_relocation, ventura:       "ca95fbd384b9c3dfb8b1391c1f007e63fb09186107db3bfe086964e4b5e4ed5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c3fce4d0d0bcd9b5c580d544053c34b8240d9fabffd92aad6516fd1836bb274"
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