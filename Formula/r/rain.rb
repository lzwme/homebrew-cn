class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.17.0.tar.gz"
  sha256 "8c43c6079081184d6526bb1901d9731ecbb1db20089dd689aa816bffba931d7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7f82081f26c244bcb1312f4edc7b4e319853bbb75ed08459d3861144c47ad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae601671891cd50c8a3f4f9b59cfa85ed21a9a5035b3317861b260b381d06d04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "062af98a20a361977599cdcef4414b66970f060ad48054c0d80e2cd9907c32b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "93deebf7b47395c0850b805d42e3276892ed5971cafbb12c7430dc5d14b20795"
    sha256 cellar: :any_skip_relocation, ventura:       "aaa65c6881b9400098e460ba971670d24281ad93fdb9e461c30f52886cc20689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1623a9d0dba1647f7fa0bf6ce56d2ab633d58845614b3b735a9840dc34eff9"
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