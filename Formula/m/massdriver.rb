class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.10.3.tar.gz"
  sha256 "aa31bc09fcaa94bcc023db8ce35473ec2a5b79a964b89c0d51279f000e2cf5af"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4047239b003e8b4d9fc5e731a6eca32abadfc1a85ebb2647ea19896154ce785e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4047239b003e8b4d9fc5e731a6eca32abadfc1a85ebb2647ea19896154ce785e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4047239b003e8b4d9fc5e731a6eca32abadfc1a85ebb2647ea19896154ce785e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6946ca7546a43f55d41287bb0f24604bb992ae6fe372e5969920913e6cbaa11a"
    sha256 cellar: :any_skip_relocation, ventura:       "6946ca7546a43f55d41287bb0f24604bb992ae6fe372e5969920913e6cbaa11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f348d26f088f1ae074238a6718b5ac723a2a88ec672ce05458f16dce1b9f8f4d"
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