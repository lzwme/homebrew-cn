class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "8267fcb4a5891481bc477bb4434ff5c86c3595237aaecbfc9c7bd370eb1fc9a8"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b15a933ba7e84eec5af5c46ad9e48d93b293d9820e411693c585f3ceda9e73b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b15a933ba7e84eec5af5c46ad9e48d93b293d9820e411693c585f3ceda9e73b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b15a933ba7e84eec5af5c46ad9e48d93b293d9820e411693c585f3ceda9e73b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6109686bd0e4b48b34fbcaf2aad85bf9cc3a9c06c8c1edb1dcd9e74a20c5fadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b5d3744c7098eff840c1dc25fdc8bdf606bee7f168ee5344ea5f627bb4d4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a733671f313a3ade141de1e1fbd101a6c23e593b43a88f3a98ac6e338fd47e2"
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