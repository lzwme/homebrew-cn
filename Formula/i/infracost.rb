class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "fdedd023a976805497fa10082dfb6c902e8ec8a10980a376eb048008b38aa250"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c731d154126a3a288c41259740efab8b523900b7ff3715adab2fbc7f3c61be5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c731d154126a3a288c41259740efab8b523900b7ff3715adab2fbc7f3c61be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c731d154126a3a288c41259740efab8b523900b7ff3715adab2fbc7f3c61be5"
    sha256 cellar: :any_skip_relocation, sonoma:        "333f43c1bb1863468960528cc67322d4b6559aae25bd2c965763fe07bbfdc817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fcf08a89dc80dd5f3638ad3c98cdcf28978faf297c25e2f7b8d29609dd672a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84015ea6665badf5e46c55d6b05cc17666009a2c7f577904306f2c1fb7b05df0"
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