class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.19.0.tar.gz"
  sha256 "6cd3dd2466d5a4db2fb8d2043482a77290eed727ec84cc2d532f7cb1abd3cab3"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276260eb6ee6d8670855160628cfa1e92905aa5bc27e466b83d87d3d9c6bb22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276260eb6ee6d8670855160628cfa1e92905aa5bc27e466b83d87d3d9c6bb22f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "276260eb6ee6d8670855160628cfa1e92905aa5bc27e466b83d87d3d9c6bb22f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb76aae55a8d058973e73cb7f1ebecf16d561f58eeae1b6aaabbcccf6e2f51c"
    sha256 cellar: :any_skip_relocation, ventura:       "9fb76aae55a8d058973e73cb7f1ebecf16d561f58eeae1b6aaabbcccf6e2f51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c740d794cf84642ac4d366ee0246988d0888da6d5c694066b9a0f012acf6faae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdaws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end