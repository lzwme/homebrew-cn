class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "efbb960da9e130526499453a9e0c0c833ad314bc1170b22d33fbef9201d083a2"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab936cd69a6d7caaaa93a835ee33abb1e2299a72f1d3a784adebd6590f8ea284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab936cd69a6d7caaaa93a835ee33abb1e2299a72f1d3a784adebd6590f8ea284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab936cd69a6d7caaaa93a835ee33abb1e2299a72f1d3a784adebd6590f8ea284"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3cef7d635fdf215aee1105bdc94cd9108f19984fc3d03ad4f0d137eb6af75d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb8fec4f261b4ac9576c0858f6a6691bdb66e6ca09437e0c9e771e833623addc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d4eb16f65817ced13b2679e0434fa06cb2dbcbf7604805c3df5531cc6ca22a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/cli/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"infracost", ldflags:), "main.go"

    generate_completions_from_executable(bin/"infracost", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    ENV["INFRACOST_CLI_AUTHENTICATION_TOKEN"] = "dummy"
    output = shell_output("#{bin}/infracost setup --no-color 2>&1", 1)
    assert_match "setup requires interactive login", output
  end
end