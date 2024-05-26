class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.9.0.tar.gz"
  sha256 "657b6c5c83774592faf69a52750378b64ffdde7ca883798a85bd01ee7c83a3fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b86d49613e45fa0318123d79840c7303be3109a03d0989703a98e13805c686e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5f00dab6d13db2f2d8c3f9db59a819ea33e5fe0c024e287b79b2dd28186ae61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4cd1cfec9fae2faa309ed3bcb8a323ab6ee14d15c616bb677fd7615ac16b7bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a05faa30f7daa3b74a58b19627f16637a34d83d54a848258c10b9eadec79a84e"
    sha256 cellar: :any_skip_relocation, ventura:        "de35a2f9b8db2ba5623b1c9a41ed9cae3b7976b25c68286ed8accec8b87501d9"
    sha256 cellar: :any_skip_relocation, monterey:       "8401a82e788737bb83a3b691300c159223ed69e7421eb668a93004bfad72f5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b70816ac7b092139c63c8bf78d53a6492bf0da4c8777be1db86507342029896"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdrainmain.go"
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