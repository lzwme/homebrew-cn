class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.1.tar.gz"
  sha256 "53f3f412cca548c10b85e49958fb1bd43c065b1d3658500b2fadaf1dadd2edb9"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d47b38f401548d093c97f1b76ff2ecd97f214b2f3de4476ce0aa35df969a83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b11f43d8f0948ea97dcf3163e779259d0edc848eea2f3d7b0a7fbe18ecbbd246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e58c74fda45ce5839c1bf0a17a66c7b3a257a4886925ed59488a3edadd48349"
    sha256 cellar: :any_skip_relocation, sonoma:         "b036c3fd937b024259cdf8e70c5dbba737e78f41f8d3e2537d892e8b4f37a07b"
    sha256 cellar: :any_skip_relocation, ventura:        "8e9e282d647a001826e944af28ce93a5393f907ee794b903815321a3c6fdb232"
    sha256 cellar: :any_skip_relocation, monterey:       "76ed06bd4d44d2be1b34d6d1008487044d9cf71bd86dbbe9fceddc4e61d48611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0898397764f2126f04596aa2e25048e5ba37772b080201bc136d761d37995150"
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