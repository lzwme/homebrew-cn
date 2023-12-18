class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https:github.comaws-cloudformationcloudformation-guard"
  url "https:github.comaws-cloudformationcloudformation-guardarchiverefstags3.0.2.tar.gz"
  sha256 "e77b4c85ad023b4ced0cc8e895a280806c397f08f9e8f736a03c6a233af6e19a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52e257eecf95c501b60213d1e868c9e70fbf7b07d47daf755265ef01dee890e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd3e30afef70fdd0d175e68a147487bff722f27548a9a0b5fff3f75d4a13e26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "620a0a7ab8090b7f8409eae6e0713af9dc5c50889f44f7a5324fdf4a97bda88e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6463f2f9d6478200ae7ce6d9b4a2ee0f9cdc8b105fdde75444a7a58c034c476c"
    sha256 cellar: :any_skip_relocation, ventura:        "352b86c0de775cef21697c8e44ff9ec350d99f84f37273edd0000dc3eee7f45c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ddc51240f71a8bd0435577aaf64befba828e0715e19738f2bb5fa9a716fd7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb07f4ceff5739dbc735d56692b35b8cee550a1ed031d52c0959fccaf5b1d838"
  end

  depends_on "rust" => :build

  def install
    cd "guard" do
      system "cargo", "install", *std_cargo_args
    end
    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath"test-template.yml").write <<~EOS
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
    EOS

    (testpath"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end