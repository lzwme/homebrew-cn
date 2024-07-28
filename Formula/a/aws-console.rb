class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.13.1.tar.gz"
  sha256 "97cabab71ed9aa1eb77203c8419856d52a0443b317014a698b152ee3b0385b88"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5aa7321fe55abe619c6171f427b89f734219f05ab825476d7e45a749d2d8df6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba543e4e84ae189f7f6c2302134f1061eb447f321558521d5bf162943a7d3e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1355fc87eac653c863f09f23041b2655df261646de09823e73be7cf42b445a41"
    sha256 cellar: :any_skip_relocation, sonoma:         "9155762c855a3ae84152974be839526b74e6af570ef80e9d0e70d7a248c5f139"
    sha256 cellar: :any_skip_relocation, ventura:        "ec17de54b737f5e3c31a644b36c41358f61c308e19b8088e7a6b30235cd37ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "71eaee609211811979f593130264f23b243bd8cbdf0d6523024658560a2b1bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb207ffb2a3fa57a4330da1f8b793769b1a996a7a100fa6b963199e93369e06"
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