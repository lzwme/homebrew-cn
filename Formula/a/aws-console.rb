class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.17.0.tar.gz"
  sha256 "8c43c6079081184d6526bb1901d9731ecbb1db20089dd689aa816bffba931d7d"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec95f7db57f8236793ef50400ddd892eb65608878f28cbd2ab832769d977cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec95f7db57f8236793ef50400ddd892eb65608878f28cbd2ab832769d977cd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ec95f7db57f8236793ef50400ddd892eb65608878f28cbd2ab832769d977cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d46b79d1273ea2bf18c8bb637890f4f9e4ec8ab08f49c2c893ec9bc15ab1be"
    sha256 cellar: :any_skip_relocation, ventura:       "70d46b79d1273ea2bf18c8bb637890f4f9e4ec8ab08f49c2c893ec9bc15ab1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed89a2ae8b58e09e3ef8df4d1d8fe69b42a973492ef24df28f7ea2ff2c5ff95a"
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