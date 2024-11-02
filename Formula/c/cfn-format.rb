class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.19.0.tar.gz"
  sha256 "6cd3dd2466d5a4db2fb8d2043482a77290eed727ec84cc2d532f7cb1abd3cab3"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dfc02fb8cef10574b787ce6b63ddfbfbd7228b8c41c39b8082c0dbd35b71f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dfc02fb8cef10574b787ce6b63ddfbfbd7228b8c41c39b8082c0dbd35b71f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dfc02fb8cef10574b787ce6b63ddfbfbd7228b8c41c39b8082c0dbd35b71f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5d23e049aec09b43b9c47ae46714ebac12f378f010fd8a03981efe87f9b2bc"
    sha256 cellar: :any_skip_relocation, ventura:       "9f5d23e049aec09b43b9c47ae46714ebac12f378f010fd8a03981efe87f9b2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48275b92d101690b7b920877ab63ca6185a77bb705799e8c8cb0432d73cc547c"
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