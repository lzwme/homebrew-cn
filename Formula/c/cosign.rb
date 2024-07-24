class Cosign < Formula
  desc "Container Signing"
  homepage "https:github.comsigstorecosign"
  url "https:github.comsigstorecosign.git",
      tag:      "v2.3.0",
      revision: "deed3631520ddeb6cc7d81ace205a97342c8daab"
  license "Apache-2.0"
  head "https:github.comsigstorecosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25fb09773ecbeffa1907e85c5f6898f2e469d5e8174c58a9108313448f71ef97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a39057789659f65e10e758906372cb663379a5c01a44d909a4e3d215a2d4af87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db9a6ceae1ac278f8593ee5a9dd3964652d6cb58aa2b1798b2284d3ee33cfef"
    sha256 cellar: :any_skip_relocation, sonoma:         "57abdaa7e2d3cbf6fe02f81abc2d6481ceae6e8138088af2a548c96ef8008d5f"
    sha256 cellar: :any_skip_relocation, ventura:        "c8fc6925dfb912d7ceec17685c074719ff0976026456217c856da2ec56fc6c4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ab9c9cbd94dcc2339dcb7e4977a546fc7399c39df7049e7763c6ecb32b5cb41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3afe839c1f604b08787cf090705f6a260a4fe50eb9c64f4606f0f4be66fb84"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.iorelease-utilsversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdcosign"

    generate_completions_from_executable(bin"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin"cosign version 2>&1")
  end
end