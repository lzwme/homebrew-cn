class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https:opensca.xmirror.cn"
  url "https:github.comXmirrorSecurityOpenSCA-cliarchiverefstagsv3.0.2.tar.gz"
  sha256 "e0d7f2f3b5fb1cb7e947cc136946810d8d9688fff78f623b8d493a5e9472d21e"
  license "Apache-2.0"
  head "https:github.comXmirrorSecurityOpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "843db151678aea3af22c98dee58d8cfb6197abf23d1d0cd08685d9d39c6118c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52ea0684388d17eaacd0cd5e302be9dc125a0f294cea82a5b21b471cd1354ccd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d911eff3c504efe6ab20ff2b492fcac26abc2953308c1dec8879f9d30ff786c"
    sha256 cellar: :any_skip_relocation, sonoma:         "be7a1979fb42fa94a6795abc9f7efea6d5cf8d05e5e5ccc83036654c7e429b9d"
    sha256 cellar: :any_skip_relocation, ventura:        "d453a12f6619ec7e475be1c729b871d918a25ce51ad70ed3a5a2dfe0b57f3e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "c34bca1e765ec47b3484f2409295cbcce5d68e0554050f7a295a402640beec1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65ceba0bbc966db27dcaeeeb6a30620f3c51937511b1064cce85ec73884e556"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin"opensca-cli", "-path", testpath
    assert_predicate testpath"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin"opensca-cli -version")
  end
end