class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.8.1.tar.gz"
  sha256 "1f15027f52affbdc79dce074c957cad5de6c220f30619895093b6beb0e978028"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21bc3557e38376968f127765e1a3c2f3b5556bf42f7244c6ea61bba0cd13578b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39a5c5c68db79b35456ada2b78ed21905776e762e8ef9acfa61b4c18d0d8805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ab5ae074f1c95cd3baa278934dd55c96606e824571a6f87bbb99ffded1a5a7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "de8593a3ee7c05c6f66ff03e35aad2fadf0d0c01beee3a3680b11b987fe14fc2"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d0372e7e123ebc669ba8b97282bce0f667969b8dcb6d6e69661cbe206d4f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "1725778985e6fab59326d09a8f2a2b5d09519ec0bfccc899dab880b144da58a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32e6951611ab2d31808bb89c01a6355b2602b081045d9270577701a52aa21f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"mass")
    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end