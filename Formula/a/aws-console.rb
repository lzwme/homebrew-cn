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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab2753170a1b75ad5f382e70de8684afec144b92cc803f60472afcee1c8a7a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dab2753170a1b75ad5f382e70de8684afec144b92cc803f60472afcee1c8a7a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dab2753170a1b75ad5f382e70de8684afec144b92cc803f60472afcee1c8a7a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b51f6a3a10b08b4255b78719bf9f08587ccf81baf3547e6adde6355d621ac9"
    sha256 cellar: :any_skip_relocation, ventura:       "15b51f6a3a10b08b4255b78719bf9f08587ccf81baf3547e6adde6355d621ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49382b180905ef909d86e188fcadb32d631261c938b8ef79ecf7085fc7f6438"
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