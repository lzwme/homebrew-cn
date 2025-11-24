class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghfast.top/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "37fb974ee0eb36ceb80f38f13141883f3779a81c79562d0ad15afcd74753485e"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8afac366635ad4085b0315480b5775e4bf26a9655576fd1411936ace323ff97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8afac366635ad4085b0315480b5775e4bf26a9655576fd1411936ace323ff97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8afac366635ad4085b0315480b5775e4bf26a9655576fd1411936ace323ff97"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f74d2d4771b90c0a0b4335eb33fa30798b4e4fb30325745ccfd6d3db362a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a701295419ac5e64f467cd1bfbcdcf6f89dc541d91b884a17e2d934fdd94692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8c6be7a39571c7631035226a6e74f536e45c6ee6d218a6514fe231cddec56e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"

    generate_completions_from_executable(bin/"aws-console", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end