class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.2.tar.gz"
  sha256 "b899bc4dcf05b6254fad411e87d8eec6dc4681b84d89f48ba789b5833266ec99"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e5a3ab7c466ec11bca9c51f7003051e74b80bed7b286ea4491ab3f63212eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e5a3ab7c466ec11bca9c51f7003051e74b80bed7b286ea4491ab3f63212eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50e5a3ab7c466ec11bca9c51f7003051e74b80bed7b286ea4491ab3f63212eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a675dd75afe9cd1580628e199d96041eac180f0646258295675577e6514c088"
    sha256 cellar: :any_skip_relocation, ventura:       "5a675dd75afe9cd1580628e199d96041eac180f0646258295675577e6514c088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e903d8ae14c0db943c514981b08a6e53094ac34c4d16a76b7da280008afc6f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdaws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end