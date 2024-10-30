class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.10.2.tar.gz"
  sha256 "56fa2d2de5aa520f545c0699c40794b2d241bf671213e497916a411422e30f1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23576b1c578d5611a1ae94387f30bf01b313d12c7aaf1c52c86c8f40474c0001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23576b1c578d5611a1ae94387f30bf01b313d12c7aaf1c52c86c8f40474c0001"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23576b1c578d5611a1ae94387f30bf01b313d12c7aaf1c52c86c8f40474c0001"
    sha256 cellar: :any_skip_relocation, sonoma:        "8936b0c69323eb40bb9e16ca3e9859125614cf4f429a52f886f9c3f8f56068d4"
    sha256 cellar: :any_skip_relocation, ventura:       "8936b0c69323eb40bb9e16ca3e9859125614cf4f429a52f886f9c3f8f56068d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701df1c565c8da5663b62daf7df36f014e0a370f6afce8b2db322677622d5e00"
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