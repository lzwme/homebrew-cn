class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.19.0.tar.gz"
  sha256 "6cd3dd2466d5a4db2fb8d2043482a77290eed727ec84cc2d532f7cb1abd3cab3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "669cdd9badbd7cc6cee055360437bfc2c41c2b20ec773a23280f07a205a1a09d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa9fc7c5c1cf510ddb2642e3eedde02e280d0877163f14ce773df5db706a80c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f66c6d5c5a1da3cd1109d0606a1f95048c45b167aad73e08ae90e1905eef04b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5085ee802ec72d38aa8ddbb07b403cb39ef82c352de5e70d8d07f1cd4ffab63d"
    sha256 cellar: :any_skip_relocation, ventura:       "4012e3e37bd86d13af8ac68fd85551036799b7b71e7c68b04a97b3926653a521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069fd2f9c05276aa06cf7c7570abf0073418489e1bc15d218bd7578beba039f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdrain"

    bash_completion.install "docsbash_completion.sh"
    zsh_completion.install "docszsh_completion.sh"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}rain fmt -v test.template").strip
  end
end