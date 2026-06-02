class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "ef884436bf9d789ede9e3023a352fa5c385b31091f7ff689539a323de87d436b"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c265dfc6fa2c3632b0ec0ec608b40b97ec5b60e497e368c136a6dc4024b72913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c265dfc6fa2c3632b0ec0ec608b40b97ec5b60e497e368c136a6dc4024b72913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c265dfc6fa2c3632b0ec0ec608b40b97ec5b60e497e368c136a6dc4024b72913"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1c65031483c1c423ee6f3419307213b3c1dd5a7a1437964dd43abfceb77eaa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2292dfae6b18acafff8728e6076973a2e660fe4d26639b4d5cdbda941693eebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f988cf098688c23c9b1007cd523d4731ee2eb56b9dcf7bb69839fe0f1dc5c2"
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