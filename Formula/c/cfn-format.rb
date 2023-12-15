class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a56e6039b4b3fa1a0171b8fa0f65a93644f415b1fb30ec8b31c1095ac674dcb2"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d50b99cd8bab02b15b2d9128c2489926dff471fb13ccd9951551f9baff950a11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af295d7ff8d0abbb2c7b6cf3ba01e76a7f45cb213f4cfcabea139b8ff867e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad9541b016425fc25d3df9a1db7e6ea11f0208ed377263cf7e78cac4468339a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c4dfe4c098c29bde2dd7d02b078cfe5ca37370900a19e8bee03ad8fb9d348bd"
    sha256 cellar: :any_skip_relocation, ventura:        "ca1677561b3dd95ad3d6892d442adb7256e313e74697b54a6f0fcf10d2f9ab28"
    sha256 cellar: :any_skip_relocation, monterey:       "78e6cec6d3c9d01d0dc18639d8adddced67ac3fb065868602699a383d53d9bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39394e6367b140bd188b5fab0d793f763c2720858d930d389aacfc4290689fd"
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