class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.4.tar.gz"
  sha256 "90310e75341ea74acccaa201c04df928976e919e57deb51767682faccb991588"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc92169dee932a21eb181678f0f8fdb5313155a7433746bd9ca6571bc4ada192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05defc937f731b54b7e6e4020c97e9bb8e71c2d11c23732d5f2e6b746db11dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b3316d254c3372ae0b90522fb937814b8e32615238a514140a05f9824006504"
    sha256 cellar: :any_skip_relocation, sonoma:         "677afb610cce8449277bb795a6f1d9b1db8ec1d7822fc6ac1efd31cdfce7550a"
    sha256 cellar: :any_skip_relocation, ventura:        "ea7f1895f38744b409079a735e666c8995a8c57e82033f2f0ebe09fbe9d9ed7c"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8aeecfcac84a297ef58a5f2f143277984bd641d63b1500aec91135fad0ad5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c175b182a1d32e731600e7da90ae4eb97ae7fd747e4aa316b6e71d09ec9497f"
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