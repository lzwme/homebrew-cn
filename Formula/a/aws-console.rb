class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "54d8fcafb118fac4c4cc24e099bbc5858b57d422a96d3dcb65704d8782ab52f2"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc593e3066a76da73a2932f28c64d886bac22d5ce4f5ba2675699190f0f0fc0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a376bee1fb2a2eeed72a65511d2565f8f3148742dfafda8340a6c2bcd89247b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567d55e0a22e3c62aacb534653c637d36b3c35a1e905c470e408665b98942df4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cbbb7ca449214ae5c77e0d9699e65326117d52b7157c0b313f7a3ff3f334920"
    sha256 cellar: :any_skip_relocation, ventura:        "92f34e368a5792b3fe33912d3ae0df28caf3693e0faf93db67da2e98b11882c4"
    sha256 cellar: :any_skip_relocation, monterey:       "b4fc2abcb9285071055d971829aeb5a5a188ce863944b3001072e450a12fdeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ba3ac1547b7256eaa5a4cd5e1d3992713039830bde0c29c68ac794aacbc27c"
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