class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "04dbb314b7f4a06ab428a868b3cc1189e0381dfb17c55caf483c4e747bbe451e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6497c099c175489883f544aa0a2490ceb1bc12da9700cc2631682ee6f4ca9f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6497c099c175489883f544aa0a2490ceb1bc12da9700cc2631682ee6f4ca9f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6497c099c175489883f544aa0a2490ceb1bc12da9700cc2631682ee6f4ca9f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e2450ca67fe104b72580e83957245c3009c72e58ab6acabbaf922eb3442579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4556a4573b3d6b681bdb72f06e1193c09829fb49c31d7cf6393f865d6c85dcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f8d3e01148d7000080fa06c1bb810d76305b8c237157aebf3a2474dbae4bd9"
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