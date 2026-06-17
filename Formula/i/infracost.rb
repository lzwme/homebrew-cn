class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "59ff79c378d43397817e27c0a1eaaa3073494b3e54d431026b214d39cc5a5e48"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6148eaf82de1b1668ee9fd34e9c579ca285bc9abb3143c665905c68efbbce6f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6148eaf82de1b1668ee9fd34e9c579ca285bc9abb3143c665905c68efbbce6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6148eaf82de1b1668ee9fd34e9c579ca285bc9abb3143c665905c68efbbce6f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd2fd10831cc6420a36e02246a846b7612ceceb93aa38ab201aecd8e46f4e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d779a50cb002876eaa7551db76aa64a5977d9803516707dd64bfb516bfca009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e541bc33e1ff0705bd987e19e9ba656ef480de1719dece9c07c9e1597446d69"
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