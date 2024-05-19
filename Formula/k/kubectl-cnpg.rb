class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https:cloudnative-pg.io"
  url "https:github.comcloudnative-pgcloudnative-pg.git",
      tag:      "v1.23.1",
      revision: "336ddf5308fe0d5cf78c4da1d03959fa02a60c70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c5a6a52655e70b13db5ad69e03ff985900171d20cc94c05655a1713794d98ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b3a8f8bfbae4d5c0f58faba5ce993359f3db8055c0e850c91cd13fbe8c48869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322c10952f608c2203b290cd02ea1bbb31d0061966a68c95100fb6d4231ad750"
    sha256 cellar: :any_skip_relocation, sonoma:         "4770b26ca19f018b9d077d1e2f4f19e5da54e4f4349e8ac71ab80d4d7178e9fc"
    sha256 cellar: :any_skip_relocation, ventura:        "6f6e5d0d2199d88915043326fd33c5029c10bf831d1e4ed1c43b1000d64dec3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5dfdb03a9ded05cab7763b6d7c3e85341c91bd77c5dec5323f1bb72ecbffb06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42472d7544b33db634c0a69d8b4a92ef56fa743916941d7fbd278f79f866c71a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildVersion=#{version}
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildCommit=#{Utils.git_head}
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkubectl-cnpg"
    generate_completions_from_executable(bin"kubectl-cnpg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end