class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "12fdd81c7f80bfcb8d220fbbb47ae784306aaf34fdd9065036043004652f0843"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0e4620f03707275e9cea41330bbc53238759b5711096ce27b8527c107654d7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e4620f03707275e9cea41330bbc53238759b5711096ce27b8527c107654d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e4620f03707275e9cea41330bbc53238759b5711096ce27b8527c107654d7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "354db7b269518e1d529684eab75ce650e7bb3f381a21431ed6aa3426bcca8149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9fc2d4e96c97799cc3d334cd4ccd58eb989c8d11b9e5fd205acee8f33cd448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d31f2ebead43417c2656e3ab22d6b68707846dfe3823771c74e55974aa4889"
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