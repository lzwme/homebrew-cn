class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https:github.comaws-cloudformationcloudformation-guard"
  url "https:github.comaws-cloudformationcloudformation-guardarchiverefstags3.1.12.tar.gz"
  sha256 "089a6268bb97c49edef45d99e5730d4c3cb0febb2a2f5ba38e2558568f685461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb00a8cef34b328c3cbefdac9516e652ff9c09eee5810eade78ff3f030727a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb1f5fb64b237d6c73f3ebfcf073811005498ce02e68975425c24beb2fc661d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd3293c56682cdafe01ed0a3c2f74e6cf4551810353aca00d5b7fd4271510284"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4623ae3db7877e5b7305bad191a7b0fbecec0943d850426bcec93236c72b74b"
    sha256 cellar: :any_skip_relocation, ventura:       "24b63300f319213dcfb222705a3445df4b90c77d939f82cd5d6e0738e048a3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7535e043e8f22b3c7b0a5611406da8dd1a39a1c724813caaf32dc3f2b72a8a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "guard")

    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath"test-template.yml").write <<~YAML
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        Volume:
          Type: "AWS::EC2::Volume"
          Properties:
            Size : 99
            Encrypted: true,
            AvailabilityZone : us-east-1b
    YAML

    (testpath"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end