class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.8.3.tar.gz"
  sha256 "3fb1de43cf2d01caa80ce28507e67270ce89a0ffb14009748ba11e754b0e4826"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4d22cf7a74e91c034d5f61c72e74aa3d8445f73e3d68ae8094916212dd7296a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d22cf7a74e91c034d5f61c72e74aa3d8445f73e3d68ae8094916212dd7296a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4d22cf7a74e91c034d5f61c72e74aa3d8445f73e3d68ae8094916212dd7296a"
    sha256 cellar: :any_skip_relocation, sonoma:        "13c87dfca017667c34eb0a6117742285743cc7b1e5692b74a6ab053579e21ca2"
    sha256 cellar: :any_skip_relocation, ventura:       "13c87dfca017667c34eb0a6117742285743cc7b1e5692b74a6ab053579e21ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a48104196cb385d26c15d86427e01400f7f5c9979e07475e021ab45b20e1bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end