class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "3821209272ded08e4a5711d0f53fc2b4fe942c1e0c667dbbe889087087490fa1"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a059938b850b268faceeb585954cdf950a5c26972697deefbea049688aeb7da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a059938b850b268faceeb585954cdf950a5c26972697deefbea049688aeb7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a059938b850b268faceeb585954cdf950a5c26972697deefbea049688aeb7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca05ac16e278b9730149caed2f27bef1cef8bb30beff14d5690bd39df54ad274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a76dffd1c46531dacff52059b102e9b7380ad0dfcc5d47a7ed604f8bf881f9aa"
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