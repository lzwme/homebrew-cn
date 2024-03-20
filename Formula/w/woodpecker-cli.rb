class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.4.0.tar.gz"
  sha256 "d54bdd92b987012988993f8bf424933ea194548dddd90b72dc6eb7cd93ed1511"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1547d7b84d6bc06432c7b67c1b370ae42e1d6873401e68189555bd8af693e863"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5022c1f4c59a2f9504dbe1e183c994a218d7272242393363287cc65afe9c2723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e768e9a77773096bc734d3e6c5549f319296ac701441156c6da8eeb8bbde44f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "44188b3be960e0ff8f7f72ed4ca8be6ac4f8136723871ea46507bf162ec17c1f"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8d548800599008f5845d9b1304f6b0b19883198e4afcbcce8442f2865d8175"
    sha256 cellar: :any_skip_relocation, monterey:       "829d3e5bfadcc8c94fe87fad13d713247ccd906a95aa0e88ec2ac694b8fbd31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cca059def6e35cb244cb6b515cff956d897966f19c6fa6a8e70f900ea8fac00"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not setup", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end