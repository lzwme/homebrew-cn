class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.4.0.tar.gz"
  sha256 "3dd05a6bb4c08193fe9ffad2d99c4d06cf205e7a0e31d64655a76ebdbbbc29e6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9696abec466a6df54490d815359ee8acfe22f9540747ef087a2513da8e0c552d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9696abec466a6df54490d815359ee8acfe22f9540747ef087a2513da8e0c552d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9696abec466a6df54490d815359ee8acfe22f9540747ef087a2513da8e0c552d"
    sha256 cellar: :any_skip_relocation, ventura:        "bee68f79650454ae70d1497ad450ef0c7f6243c3f62b52cf45c76d4bf1042dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "bee68f79650454ae70d1497ad450ef0c7f6243c3f62b52cf45c76d4bf1042dd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bee68f79650454ae70d1497ad450ef0c7f6243c3f62b52cf45c76d4bf1042dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c046dfbecb09e957c1baa91e7230ec283c321c8774915849ecd4915181bdd33e"
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