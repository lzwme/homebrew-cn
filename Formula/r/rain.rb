class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "2cdf174a26bf5c73c267e09e8b81d6a2142d8d3ac265b1b002868fda1beea0b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cf7e1503ecbb79a53a938d91ec0c1a626cb6295ab5f63b03fb2f7fe3579b5a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "837a8dedd5b4d9d8e6232b80179178a481593ff690c31415ae77788f7c220ddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4c0868a29f9255058d73db264233cc803bd86dd5a1313157339bc57b8ae4a13"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b83a49d5e4190c45f6450cca03c5c923343db0aad7ebf87e71ff4c65c73cb84"
    sha256 cellar: :any_skip_relocation, ventura:        "02cc875a387539109f53cf75a0e4b65b73f589a1c6430ce17df6c134cb1bf0a6"
    sha256 cellar: :any_skip_relocation, monterey:       "41de027fb1ec835fcfc1f7737134a3663e3f742c2b43a834ff903bbae69eb52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baea9d6412bfd00c8f7a3187a40e83d4aa878a4a61d69e37341248c305795fdc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/rain/main.go"
    bash_completion.install "docs/bash_completion.sh"
    zsh_completion.install "docs/zsh_completion.sh"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/rain fmt -v test.template").strip
  end
end