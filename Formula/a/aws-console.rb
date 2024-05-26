class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.9.0.tar.gz"
  sha256 "657b6c5c83774592faf69a52750378b64ffdde7ca883798a85bd01ee7c83a3fe"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d415e991bc3c68c41374aba3cb62264a4eb418e64a84d14bb9bc550c2f65005f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292f8945df56b997002a8a5eac1b0729060e5212df4cf0305688f878b05e3fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e3aa106b7dc4869fe6b8064f7d7867d4d889b91c398ecd7417584a3752b82c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c0319f4c5a4b70fa03d6606f0010ad64c29b2f98391081fdbf7a2103b9316c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1e87239a238d840183c201c904a8c78bc6315e1efded909ecbb88b26dbdfad52"
    sha256 cellar: :any_skip_relocation, monterey:       "293c8a4deb31e26850de7db11eb323371e459dc13335e3feaf47898bbe6bc1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eae166ffbc250985f0abbc7421a68ba9b8e777fb6eade521a05aab37bf3ea7f"
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