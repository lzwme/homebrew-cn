class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "5e374b313218a89910290b6983ae6a1116b6f81e2ea07806240178dccc549a0d"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f53ab8ac0b159a0f6c32272d9a86ca081607e3d96b9f4e0c3b9b7d0a618491f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f53ab8ac0b159a0f6c32272d9a86ca081607e3d96b9f4e0c3b9b7d0a618491f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f53ab8ac0b159a0f6c32272d9a86ca081607e3d96b9f4e0c3b9b7d0a618491f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb7326e48120e67b8f379b3c326aa8f1175930d8452973745cfde16ebcb8611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa752312d3717d63aaf8a14b01f236a90a4f9064910314df0c0ff104b9a57587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e87c242e946c8333f3e76b83840165d3c0b28083b2b9c1b8ca56b0a5ccabba"
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