class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.107.tar.gz"
  sha256 "8eb13c45927601aba3b228ff968402a37fac92face55535189a2e5d3f3fcf344"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71f5941c963e50e63874143c7e45c714f5903be4a476143e32b7ff4f71dbcd0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71f5941c963e50e63874143c7e45c714f5903be4a476143e32b7ff4f71dbcd0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71f5941c963e50e63874143c7e45c714f5903be4a476143e32b7ff4f71dbcd0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d064663ae47ee094e56ac05e44ca3f0316fb4a90a997ec5a9cbdbd086243c6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a368d4238901dab340baaf2e837b1fda2efd7f9b55a543b6677f789c92833f"
    sha256 cellar: :any,                 x86_64_linux:  "022705695b2c7e1fd29bc462432ae81ef1ce5bbae07218c555d8341c06a3a0db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end