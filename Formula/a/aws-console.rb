class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.0.tar.gz"
  sha256 "908d0370aabb4053c57853f5226a4d6865562db974df8b3ac624325b1006a435"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f834763e1ee22f7ea652ceae18ae90b783d3a425a6a63bf2538856b7f97deb28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1f1bba123dbc0dbfacc851571562ad948c4bfce7ae46bb2bad740427ff6d25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aacecd472425a6b8ae7cc627fb0db91803f4c83cffa0e3215fc789a4fe1d6854"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0f1ac9dc30356103ddc19b4bf5ea53df615f810134eed0c358b825b21aba70a"
    sha256 cellar: :any_skip_relocation, ventura:        "c539ac33cc2f00d5d99f85bca04cac583fdee2edcd829c5f4530a4bd73d7cc3f"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb3c3b69aec9e9f54d2a610fe82c440a11fd302f1a33d3679e76c21fb610603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6c7434a57cc914f2d43164285ebca98cf332ca6c3061a9806a71d399304e1d"
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