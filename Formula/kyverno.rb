class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.4",
      revision: "2f1790a2a39052227e3e8e9b02daee616958eba4"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7a21488fc34e6b0c33cc7252d2311dfeb091d88e9afc7b7539ec9c655e7d01b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12aaf5aba023a4bb2d1206635462c99a9061413c0c09ea277bbfd02ec68ac407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14806e73e01c6d4d4def5e90825482aa39c1bc188c775f85eb0f8cf15c4c8442"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d3a47991f57e2dec4d5d2c59f4f4862a10eb7b74869b86600cb60262e87f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "df90c8b01db1c753d793a7593c269e1d4a34b0653ef1252770d849ce1fc3b097"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd6c8b8ca71879181c8844637f11afd8ff13e850cb3e35e3e26bcdee1470609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae8b29e1c10adfb03b5a7266297dbc676a148a57aa06252af1804815fe0d4be"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end