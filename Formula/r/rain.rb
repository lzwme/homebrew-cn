class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "54d8fcafb118fac4c4cc24e099bbc5858b57d422a96d3dcb65704d8782ab52f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3066e01751285e35ea559c28aff54d350c59deb4040bead520e5f75c20292fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51f85ab38833348d2de426fa4fe264b335c8d676a0a58ce98709f926b3a50805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a210c9b7c6b9e6d242c6eeaa7ee789510baa9272118aef5325f810716ecedb97"
    sha256 cellar: :any_skip_relocation, sonoma:         "bda22bc36a0bc148726c2671ccb290fc0480c9012f66ec7e8baa33250dd93892"
    sha256 cellar: :any_skip_relocation, ventura:        "dae5b0f20ad8f63fb0249c475130cc5fc5085a38e89631560ded6af81407f931"
    sha256 cellar: :any_skip_relocation, monterey:       "92b65081c65f3641b0e35f3ad6e2af8ba8b1ad5674511ea2fc9d25127f8aa864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812d17642fbf800d0173b6b6de16d154f7b2006cbee46251eb06b1254468716c"
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