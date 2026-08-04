class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "1130b81f668d9ee0610061d8ce2bb8d7a3ea5fa84481e3ffa97ac260de9c261e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bd80f9a9cef7d6b878211b1b8e2fe573a9fef732e5beb403d6662823f4f80cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd80f9a9cef7d6b878211b1b8e2fe573a9fef732e5beb403d6662823f4f80cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd80f9a9cef7d6b878211b1b8e2fe573a9fef732e5beb403d6662823f4f80cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "83854328a43d9b1aed62d9041d53425a7afb4eb4c80b120f36966cd87d0f56cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957a0aa44af3e100c681dce831d7c5b12b6eaa072bcc1f2661942b9e986910f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f22d7621f0f2744356edc58bf543304ff4062799bd61a54eeb7faad15602ba"
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