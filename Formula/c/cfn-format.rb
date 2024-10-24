class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.17.0.tar.gz"
  sha256 "8c43c6079081184d6526bb1901d9731ecbb1db20089dd689aa816bffba931d7d"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f469cfd58c5e8a4905b707e4c1a4f4be7de23fda398e7a055bec6381ba1f1eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f469cfd58c5e8a4905b707e4c1a4f4be7de23fda398e7a055bec6381ba1f1eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f469cfd58c5e8a4905b707e4c1a4f4be7de23fda398e7a055bec6381ba1f1eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d1c0b8dec59531ec369eb685fb47bb052d470e1648aa1db8bc664ef91d6cf81"
    sha256 cellar: :any_skip_relocation, ventura:       "5d1c0b8dec59531ec369eb685fb47bb052d470e1648aa1db8bc664ef91d6cf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092bc126bb6e14bf82dfdf894054a1adaa4ffc54b3d4a1dd575dbefc39f55033"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdcfn-formatmain.go"
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end