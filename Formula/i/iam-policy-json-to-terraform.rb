class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https:github.comfloselliam-policy-json-to-terraform"
  url "https:github.comfloselliam-policy-json-to-terraformarchiverefstags1.9.0.tar.gz"
  sha256 "e6bdaa4643ff61b2affdb71ac6008bc9857863affb9cdcc7519f07208ffa5953"
  license "Apache-2.0"
  head "https:github.comfloselliam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146b74de25e3ec985cb659547b7dac91fc0182b1a5a0b129d26d01d5ae855344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146b74de25e3ec985cb659547b7dac91fc0182b1a5a0b129d26d01d5ae855344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "146b74de25e3ec985cb659547b7dac91fc0182b1a5a0b129d26d01d5ae855344"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f92742a9277e24c567ea99d511ac2d3fd3b482a1d2ed58490bd1ba35899ffc4"
    sha256 cellar: :any_skip_relocation, ventura:       "7f92742a9277e24c567ea99d511ac2d3fd3b482a1d2ed58490bd1ba35899ffc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a236a1e0700bf6e4f327bba048e91de532b3e5f0d7dc03a3e847e34c3de068"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = pipe_output(bin"iam-policy-json-to-terraform", test_input)
    assert_match "ec2:Describe*", output
  end
end