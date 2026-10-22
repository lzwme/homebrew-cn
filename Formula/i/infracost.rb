class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "2747957ca6a3b923b49a9440f4f18fa337ee445ede4d359b606e22c1cba3641e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28dc14351768253e58177d3a5ebbcf9f38170e3c6da0ff33804a444fd9142d03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28dc14351768253e58177d3a5ebbcf9f38170e3c6da0ff33804a444fd9142d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28dc14351768253e58177d3a5ebbcf9f38170e3c6da0ff33804a444fd9142d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "560253ad2af7bb69658da9225811e6118fd97ad05a48d0dee61ce1a4152c2691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d071a3e000d920be8f0df17e394b2c6405f3f1cd631a1e5113cedbbb5d99563"
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