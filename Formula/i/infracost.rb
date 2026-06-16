class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "f6f7bde089856c60bb177b52060dfda991b8d3c46a4cab4de3ec43be084841ab"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22f45b12fc79767796c55424fda7c4fd8b86b86f7b25186c96e71d29ab22b241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f45b12fc79767796c55424fda7c4fd8b86b86f7b25186c96e71d29ab22b241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22f45b12fc79767796c55424fda7c4fd8b86b86f7b25186c96e71d29ab22b241"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb253fe52b28f0a2eb75ace94a60183bee5625a14a2cd5da2d15a8553af7dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b35e4716dbfcf799d748db65ca7faf5032159de0c48e93f404aa6d539b457c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5158a75d2c90960be3f2c833be326b129415b70b5c11f187946e34387c3fc1"
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