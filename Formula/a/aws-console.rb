class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.11.0.tar.gz"
  sha256 "703f06e0c0aadcff560c745b96a012c82c27da2ea486c85893efdceea79cdd13"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "382ebfe2a3bc58bdd3c571e61439455b06125ee6fa1b89f6934d90fb5f87a489"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8512dace2531433ed15b1336c9079a62c82d8363f859fbf63beb4b78ed76a8a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b719edf479873c34042664f758386086afa42282b72af3a56b13f3b0deeb8fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b8f25ccf80fe3c9d71e0bb2005519178866cd4c7c5203983babe46ef44e02a4"
    sha256 cellar: :any_skip_relocation, ventura:        "68b74c50816a1786006509b418a12143d905fde27507777cf3d1ac8c11fc6f87"
    sha256 cellar: :any_skip_relocation, monterey:       "498c58eea50296bfcc63104220a9c24419945b5e6e105dfe190dd25754032c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f1e2b19f06490c1aa02deab570cf73ca93787bac948a198add876c50d9d1027"
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