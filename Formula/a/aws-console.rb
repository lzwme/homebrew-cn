class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a56e6039b4b3fa1a0171b8fa0f65a93644f415b1fb30ec8b31c1095ac674dcb2"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65a5c81071fd5f9754176403e94472a109f42047121ca4ca0ecf692320370134"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4db4364fd9931a94deef4bca246708697e772c4c6fb2f29787482a9d7bc82bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1f9cc2f0b3605677e6c43f221ac0f8d00faa376d6ad1338bb2f69c1a4a9349"
    sha256 cellar: :any_skip_relocation, sonoma:         "e39fab0ce8f4e77e013362814534e1ea97c4b3d55a5acd6c88299717211a4838"
    sha256 cellar: :any_skip_relocation, ventura:        "e5de4d1f57dd4d911870c6ae33110d862bd8a2742552ff29f62cd1d2c8456256"
    sha256 cellar: :any_skip_relocation, monterey:       "00322bff7ff302b60d204e2136ef898dbcc4c73db4b5b2635e32ff335b8f2ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c67de710ebff2cab54757016ea5693197ceb237016f63d3c1ed1bc9106090a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end