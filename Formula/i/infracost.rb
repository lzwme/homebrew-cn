class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "63248e8f93c9a1c82a31b950cfb958148295fa47b0fcc55e0b4e81bc77261ba4"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55fca7a6fae97989221f8d085e3e88f654ee7d04c72fb71a15524a5888108eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a55fca7a6fae97989221f8d085e3e88f654ee7d04c72fb71a15524a5888108eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55fca7a6fae97989221f8d085e3e88f654ee7d04c72fb71a15524a5888108eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b6328e6af92fee841c67f9f62d6dccadfe64aef68c10253a9540fba1fcf348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9e23e0c49cbab4a9dbf54cc3461a2e357f85e6a7ba0092dd2bd9406038474b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab73f68eda179e402de62606ce2e0131577245ac1164c337540a90feaaa12a1"
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