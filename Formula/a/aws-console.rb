class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.0.tar.gz"
  sha256 "93539723e544db865f99e65afcdd4f53b4d7ec7e99a283cf652619145901c165"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7684bec288279241578cb3496ab69de79a7e3263331459a35fff8298ea871877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8329d023fe06040ab849aae3229f3928b3fc97e76156c8a43a4010273a47fe01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f76847a3673f712ddaa46c39a9509958ac85ba51e9cb189a2699cbded30ee57"
    sha256 cellar: :any_skip_relocation, sonoma:         "e98f431ad275a63772a3f77403572436c86d412a7a91c2556822e0a88d9eebb9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7b302b5f6ecf56ed1cd75b59d9bc8961b79dadba938e7b29d0b75fd1fa4482"
    sha256 cellar: :any_skip_relocation, monterey:       "82496a6aee882fd705ccfd1b48445596a8c24cfd07577786fbcdd3b922ebaa92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a983dc866aedf5b1f815ffdc1313ba1f084643a38dff153d8484eb5394b3398"
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