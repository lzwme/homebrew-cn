class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "f4d94edda183eadfd7eb7d841ceb079447937baa60ca1f7f224186d16545313a"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e02ba691b874604fcc3b9542dc1e0c4471401591bd8f7348681cde652b824e83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02ba691b874604fcc3b9542dc1e0c4471401591bd8f7348681cde652b824e83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02ba691b874604fcc3b9542dc1e0c4471401591bd8f7348681cde652b824e83"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6bef01f880485ecaeefb52fc12a8d118949ca932717e5ab001b31021ef21cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b522f9d7e68658cc2eb4eeac8790548d07d556a1000e313fd715c88f9be9a322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd72e6162135c80867b05056415e043a6eca20206518db7da4d9cc244a71903"
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