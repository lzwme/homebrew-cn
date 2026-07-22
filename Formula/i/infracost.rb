class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "5803f73abd27fdbef04afc72089ba437130f91b46c87e47932303799be81b0b8"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f0d9b4b1c6a7dc3c4f94fb946e8394b32bb37a0f3a8aaff7133357ee8474b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0d9b4b1c6a7dc3c4f94fb946e8394b32bb37a0f3a8aaff7133357ee8474b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f0d9b4b1c6a7dc3c4f94fb946e8394b32bb37a0f3a8aaff7133357ee8474b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac145e8487655605889c9c13cc5ab50614af6b76d2f831c8e1c2ed8b5410a7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339f826da948bacfe18352d9b56410e389db41a9497f1256ff4f164644c29417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69c5e647bf4923d021d994de6c1f089c9978e23feb8448cfeccae006a43d7c1"
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