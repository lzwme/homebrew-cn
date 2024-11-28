class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.10.6.tar.gz"
  sha256 "ff1cecbaba75ed75fb5f55b14c4d3a8c4ca4301b1592cec0658da4d0c98dc866"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06f9709eaabd1c22008047c9e3faaac2456bb90aaa3ad8bd5118706098fcde2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06f9709eaabd1c22008047c9e3faaac2456bb90aaa3ad8bd5118706098fcde2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a06f9709eaabd1c22008047c9e3faaac2456bb90aaa3ad8bd5118706098fcde2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5261bbb1811139caaa65c6454ab5b042999509900723c92bfa9730480212d7f8"
    sha256 cellar: :any_skip_relocation, ventura:       "5261bbb1811139caaa65c6454ab5b042999509900723c92bfa9730480212d7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a04022d83fd2debab42ca686dd8e1931ae2d0fe11749a206d99a55c80afd9b"
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