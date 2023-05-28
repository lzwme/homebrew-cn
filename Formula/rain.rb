class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.4.0.tar.gz"
  sha256 "3dd05a6bb4c08193fe9ffad2d99c4d06cf205e7a0e31d64655a76ebdbbbc29e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6acb41c9d31ccef7336916154c73d178e3d1cde555156ed8ad4dd577250ffe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6acb41c9d31ccef7336916154c73d178e3d1cde555156ed8ad4dd577250ffe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6acb41c9d31ccef7336916154c73d178e3d1cde555156ed8ad4dd577250ffe7"
    sha256 cellar: :any_skip_relocation, ventura:        "d2a35a5209f2b342b1430d895f16dbbfdddf39074b30c00bc6faf2f037778df1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a35a5209f2b342b1430d895f16dbbfdddf39074b30c00bc6faf2f037778df1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2a35a5209f2b342b1430d895f16dbbfdddf39074b30c00bc6faf2f037778df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c4e04007ce8ea67cc0f81a81f3f4e20be199cf50256b52f2c8abe105156afa"
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