class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.0.tar.gz"
  sha256 "40e9230c94e21b7bfe5288f1d4add3b3ee8a2e442a89650f8066d39a8c8b4f53"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3dd33f784718ce6b03f989eac8ccbe124414c23f53f8f28dacc669e24f71277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3dd33f784718ce6b03f989eac8ccbe124414c23f53f8f28dacc669e24f71277"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3dd33f784718ce6b03f989eac8ccbe124414c23f53f8f28dacc669e24f71277"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a3b72af2e83c3d6271fd5042e2bd40536450994ac0330dbd73172d78b031ea"
    sha256 cellar: :any_skip_relocation, ventura:       "11a3b72af2e83c3d6271fd5042e2bd40536450994ac0330dbd73172d78b031ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8096b0dd8dea4de5ce74290768f27ce14b44d158fac69d240efd798da6937f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcfn-format"
  end

  test do
    (testpath"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end