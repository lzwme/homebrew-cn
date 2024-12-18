class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.1.tar.gz"
  sha256 "04cddedbe35074e66fa1683dacf9dc5cbb3913bcccaf9ba7a587936b2bce928b"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ec3d0e741e8a9dc94bf9997595585ef46f1656aee6cc3bd66fdd90d00495de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ec3d0e741e8a9dc94bf9997595585ef46f1656aee6cc3bd66fdd90d00495de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0ec3d0e741e8a9dc94bf9997595585ef46f1656aee6cc3bd66fdd90d00495de"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96775832a8ffbd5e7e4d555e380be456a487e54ceb1414b49bbc7c97d09c630"
    sha256 cellar: :any_skip_relocation, ventura:       "d96775832a8ffbd5e7e4d555e380be456a487e54ceb1414b49bbc7c97d09c630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b12844ea5f31bc9d91e3b7a5d48334a68ca86cb044323d224937ae296240bf"
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