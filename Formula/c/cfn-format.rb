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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a94e9c2ca4f6fdcca464759cbfa7efda78b54ffe3924186908ed2075b676315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a94e9c2ca4f6fdcca464759cbfa7efda78b54ffe3924186908ed2075b676315"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a94e9c2ca4f6fdcca464759cbfa7efda78b54ffe3924186908ed2075b676315"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c66ed9512ba2c3e3c4c61500f1d690fef539565f66f0937f0c7e15943ceaaf1"
    sha256 cellar: :any_skip_relocation, ventura:       "0c66ed9512ba2c3e3c4c61500f1d690fef539565f66f0937f0c7e15943ceaaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433f31f7b7a1fa8e3d2f965afacf2375b47ef13d7b8232068a3112013128cedf"
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