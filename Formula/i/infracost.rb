class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "0ce201a2d990448c437c28b308dbb231574d70ebc9b7f536bb408b3a244ea55e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60fb7c38d125d47543657071bf58668a0df47344a700990f46ec1b757951c853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60fb7c38d125d47543657071bf58668a0df47344a700990f46ec1b757951c853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60fb7c38d125d47543657071bf58668a0df47344a700990f46ec1b757951c853"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f8ea4a151851f79251af281ee8a1e469a399d7c5eef27cf4ff4941285d7e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a49fdb222bebaf7543783ed319f7c90a05207e3a18a85aa396527721190c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f48820c757c2069a02ab277274b6ad6019b8110c6845cb0cc5db6552b0e9b5"
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