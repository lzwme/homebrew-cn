class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.5.0.tar.gz"
  sha256 "fdb2548cd9247370c2cd792903b8f7be03772636b037b583155fb8b3e069106c"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d086752906498cd64832cdaac1be25860de469958a69b9485d40ddbb55fe7f78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0bdac579b6d9379b31c97b814fd93bce2b00f513c511907504e86275624dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccb80e73feefc3e0056bf3cac8bf3b171a2a673863f52973b16dd959c90d3fa3"
    sha256 cellar: :any_skip_relocation, ventura:        "3eb5fa6c0627ffd8adbce639352cd230b3c1f5daeb38dcbcfdb1af3025e7feb6"
    sha256 cellar: :any_skip_relocation, monterey:       "525cc2687728a0ee65d4acbd9942fc6fea59752946a2655ac56d9e84262cd2cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f9f0fdabfc82610bc7c3130759cab3d96429e3897631451f6f5d336191d2163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037e93802c0076eb833e7318d2567df1385447395758a67f25dfdeccb85a6e82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end