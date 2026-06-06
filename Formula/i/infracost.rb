class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "851fcd8225772abf9f52b3a73bc16e780ba41adcefa0867de9ca2922f9532189"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ef0080c6be1d27d5fc0faf307b8dd1767b111f271b82a30c1721f112ed5755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ef0080c6be1d27d5fc0faf307b8dd1767b111f271b82a30c1721f112ed5755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ef0080c6be1d27d5fc0faf307b8dd1767b111f271b82a30c1721f112ed5755"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb7f5d7141a7d461b7c4bf3dac8a16157bdd2c2619f778a4cd7da243abbbc89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6217aa08f65ea440e96373d0345c28caac3a1c72d68318d3ed060096d31aaa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46de66732cadff19314d1f1d402166347991e2b1867fa44a56a491f8a5f4ba15"
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