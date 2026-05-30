class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "1f99f2cae282ff4708e02c0ec369d8949f0823e86c3ac9410a9b34f7cc5f9278"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec7a7af161260b4cbff73577c035881d5bbf2c7ffdd0963aae57f40157ccc2b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec7a7af161260b4cbff73577c035881d5bbf2c7ffdd0963aae57f40157ccc2b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7a7af161260b4cbff73577c035881d5bbf2c7ffdd0963aae57f40157ccc2b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "981d7a279c4777a0a4260c0fcd945962f3624efc8b21217a0fe6e52e2ceef9c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0ce8deb7d394479900d910618c5ef79855f0146bf5b664aa3d04622ce1e455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e5b069f49e39e27f58e2273b3e4f9fd79428d37c04e235872505f7f6ed23bf"
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