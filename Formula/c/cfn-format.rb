class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "2cdf174a26bf5c73c267e09e8b81d6a2142d8d3ac265b1b002868fda1beea0b6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e643010969b7a091cd2f7ccaf7c734c4f53956e7500dc3656a1d44db968544ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1a19334c5cbc3c6b8b11b6bfb997338f3e423e4acf51d4c44590071d0cd1e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f861d60db8c6692d8b1f62c53f0ac83dc9ebf5f2124bd8e5582ea639163326c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb4a5caf331051b7bf2e29175a32cc2712f2da20be488cf83f6ddfff89793e6"
    sha256 cellar: :any_skip_relocation, ventura:        "a90618cdbccec45329ce75e9c3114dbe6f754748e79e49a07acf9aac7cd9f0f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c403d85630a85b510ea1f10974b2bcc69a6e329ef26ffbb5a224ca21c549e700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b97ebdb65a8d0a91203f0e948cc2f8b142e93abfcfc39f26598e23badf412fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end