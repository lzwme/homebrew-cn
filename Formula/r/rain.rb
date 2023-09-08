class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.5.0.tar.gz"
  sha256 "fdb2548cd9247370c2cd792903b8f7be03772636b037b583155fb8b3e069106c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c20cec4f22de709d4ba48c32656ba9b81e94e104b4557889a575fa17181f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad67ac3ff633a66e63b07787b58ecc30983b35671248e5f8c67421cdc0773d8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f55c13871ea71cc4f2e1e67169fcd601e88095df0b242b801ddd2247d6f70e4"
    sha256 cellar: :any_skip_relocation, ventura:        "6c2a63d5c5b79494f571eea14498379e657dc547bab7b3a1665e2d19d2a165df"
    sha256 cellar: :any_skip_relocation, monterey:       "fa7d9fd2c88e78c8d26c5673912c4fede65b1f68b80bb9315250b945d0226f43"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfaab3fa1bdd5cfd2357fc0d782083e90cc9084e1e124547477037e29dc76079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1327c803b11302d11bd9fcddcc1ba41a32d452c631ae9eb3c2ba6b03689ce714"
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