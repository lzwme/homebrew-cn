class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "e71198a30fea31e21eb744bf9ef14a8fdbc1a06796d14c021d1e6a7fda1b2057"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f3006c1adb15a2f1949b6f1b3be9a7ccd201f3fe75d3e1bd4a88ddd8653a90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f3006c1adb15a2f1949b6f1b3be9a7ccd201f3fe75d3e1bd4a88ddd8653a90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3006c1adb15a2f1949b6f1b3be9a7ccd201f3fe75d3e1bd4a88ddd8653a90a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5efaf71e18b7abe8125c97c6d394273e02e87ff3f365eaff130f0a3233d047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0b42a20b53d1ab25287dfe004eea5cea578c0a6fae6f458e55416cbea81758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ef69628fdef859a1362dfb07071966969cf3255e90ea388cb3b3d7e53bf845"
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