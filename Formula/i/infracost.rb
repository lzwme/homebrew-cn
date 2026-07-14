class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "adddfc608b9b5e41f047aa849d4f456e94a448f37b942ae17c7ee3028c04082b"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39ca2ea8c179fabf005e9a64fb0f716ae1aa1e666f62f9a37d22b9a0d5839702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ca2ea8c179fabf005e9a64fb0f716ae1aa1e666f62f9a37d22b9a0d5839702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ca2ea8c179fabf005e9a64fb0f716ae1aa1e666f62f9a37d22b9a0d5839702"
    sha256 cellar: :any_skip_relocation, sonoma:        "c516cc551cba27c52742dfc717fe761d46963cfe2dfcb9a2afc7d64453653e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c7b3d3932437d025eb10fbe54b2e0d32ed880e6671bf18354f0925ed8a8da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6682efe55d2398810cb69ba87fceb5a05d8df642c3bcc7fe97c806ae287b86ed"
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