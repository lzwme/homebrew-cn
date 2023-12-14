class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "2cdf174a26bf5c73c267e09e8b81d6a2142d8d3ac265b1b002868fda1beea0b6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3e5ae3f46a74373b91abab88b9475ecf9883c0813b1844f9ff2905e2f0884ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc325558a17fa1c0f28c06e74c41104dd75e34a3f10e5c24a22cf090fbad90cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8e4f36895ff17b1572cd7763252a6cda0055b69615a87b340bc53773347609"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a0fc6249dab52bca95a1407ec7d837d07840e9ab2eee260c86f7f4ae8171f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "d7dfe4083398f04692f0e97e854cf8a6803a932d1a4c8a6ae455447114c9bb40"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd2f27d0c92c5bde0c463cb31ad899ce9c1d1d82454bd4708f544d346b153da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b81b448270b480d9091d120bc3af6d519e7ded78120303a15035c00d060a1d3"
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