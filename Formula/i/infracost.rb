class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "24a40a77f7e47653633ac1769b7b9fc6cfc0b461f9796b90d27d7174832c23c3"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6570ee74237677f4bb052842e3f1b9797a2737d10e87020fd7d72e8e53352e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6570ee74237677f4bb052842e3f1b9797a2737d10e87020fd7d72e8e53352e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6570ee74237677f4bb052842e3f1b9797a2737d10e87020fd7d72e8e53352e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99838483b925d4d18cf6b3156319919560136bd673ff94cf5332f73acd35b4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f894621f29c4a5acb2de2d65c1284308ca8b5b798f2ee10ee21d72d40f78e507"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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