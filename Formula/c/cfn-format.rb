class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.2.tar.gz"
  sha256 "b899bc4dcf05b6254fad411e87d8eec6dc4681b84d89f48ba789b5833266ec99"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a103c8c6df8771b05d669e5de7566bb4495ca45ba450db25c83e9bc3c6f76253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a103c8c6df8771b05d669e5de7566bb4495ca45ba450db25c83e9bc3c6f76253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a103c8c6df8771b05d669e5de7566bb4495ca45ba450db25c83e9bc3c6f76253"
    sha256 cellar: :any_skip_relocation, sonoma:        "532e9e048a54aafca34e42535427fa7020c54de0457ca0c1892bc24810827561"
    sha256 cellar: :any_skip_relocation, ventura:       "532e9e048a54aafca34e42535427fa7020c54de0457ca0c1892bc24810827561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a54fca55721fb0f611cd2b0fd4daf02c25e4232db235e99a3acb9f9ca6b2f6d"
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