class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "84445f7e2422a18607aa89df9113f4a82774033329decd6529c4ddcbd17e49b0"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da9da453bc5ec6840d40afc6897a5353bcf771f4b0daf7378518f7b366410c88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da9da453bc5ec6840d40afc6897a5353bcf771f4b0daf7378518f7b366410c88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9da453bc5ec6840d40afc6897a5353bcf771f4b0daf7378518f7b366410c88"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9b63b001a58d2f8e7617a834973044146b3661313b55d61c8610bb02b20fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd6a22278751a6fb6db3b6d508d514c2c25952db499f7bbc7895793f6ca62dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb8633346da08fc4269d64bd7a078bb99bf602b7d3b341eee996f55af9e6db2"
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