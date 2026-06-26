class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "fcc57854711a058265baed705e553cef8f58bc8db6339d0710bc0f771543f5db"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b63603505b5c694f963ee406c9d442038b7d66e44c3f01052e6ff2ada6c2c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b63603505b5c694f963ee406c9d442038b7d66e44c3f01052e6ff2ada6c2c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b63603505b5c694f963ee406c9d442038b7d66e44c3f01052e6ff2ada6c2c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbdae3bb4ee1772a3ecf66dbb515230550a4b6fac00a536a1a2c149a03ee9eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2331146620c1320f4707e0dc30814d1edace43b32ed3991c566c04b62341cd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810bd8d261a5dda6b2d4ff7050a69d21702b88a088798067c9f9b28ac56e0160"
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