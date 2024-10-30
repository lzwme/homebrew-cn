class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.18.0.tar.gz"
  sha256 "b742cfbbb89740f4633fc9811dce9bac2d91612b9c9384d07439152f5af29daa"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f891e5e4a7e5dfe7c446e89621239f5abebaae00f21c7d0614550db1adc42f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f891e5e4a7e5dfe7c446e89621239f5abebaae00f21c7d0614550db1adc42f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f891e5e4a7e5dfe7c446e89621239f5abebaae00f21c7d0614550db1adc42f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b503dea0bb6754fea64ce646fa89c876d2e700a8048451fd3eba3bfea909c48"
    sha256 cellar: :any_skip_relocation, ventura:       "5b503dea0bb6754fea64ce646fa89c876d2e700a8048451fd3eba3bfea909c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34a0152b1230e0a78042ae9f31d4a786fd1e860c3092b75c4f00bacab15a397"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdaws-consolemain.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end