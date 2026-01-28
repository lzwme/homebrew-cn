class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://ghfast.top/https://github.com/kyverno/kyverno/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "5dc3c33e0a920c92e1884b815b13fe24f7e84808465748bad615b90ef99714c7"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a6a14897e287557d29693cfe6ab2159bcf0561c8a3c455632d189bbfdf5b2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561811fca6a5afbc5a2579c8ce7eb4ca1ece08e8eb4385612103992639c6b4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b06e05293e48c223ff60a04f09abd457acd3c3608f9f0f9e5d3bdb478ee1cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d244ae289be44946ef906606b8da46cef0a081c3c573450676edc2e9214f7cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd03da3430b2c5754e4ae31836d1ece9ac2e1e36af71161289bad5afd369815c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509f8638ae871996511940fe15ffd22201920d00b923faa847f8db56f95676e8"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end