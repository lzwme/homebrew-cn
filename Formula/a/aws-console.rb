class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.5.0.tar.gz"
  sha256 "fdb2548cd9247370c2cd792903b8f7be03772636b037b583155fb8b3e069106c"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35c0d9902624f2c34b8286bf0b02a204e85f6422c2176fe7cab332650c7f8cab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120ffef2dca192001fb27a94daf2d7253a6a4947950e6878a5c5555f2d797ede"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61934820f4926cc462d2c345192bce39a9cee60182c16289fe44245cb8d95047"
    sha256 cellar: :any_skip_relocation, ventura:        "3f317b9a9dba5828a1b5932afb0ea6e4af728b32bd66f9abbf69da443fbb2c40"
    sha256 cellar: :any_skip_relocation, monterey:       "94cc4df2f5c18e1adacd54ce23f34fd674d7af268f87b37c41255d37db98d450"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a4e9d65075ec92eb23d96fdc0c980630cf9e16fcdefa9327cf876628800abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd173ead4d630f5a3cbbae5191a2b8b7af687e01ceada230544ce322ec3ba7b"
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