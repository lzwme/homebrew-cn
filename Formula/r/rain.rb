class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.1.tar.gz"
  sha256 "53f3f412cca548c10b85e49958fb1bd43c065b1d3658500b2fadaf1dadd2edb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20b93a9eba1348fdd8d04591b71b507e7381a9f572c5fb5b31e68fed2d10f8ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b0eef2b1487c43b302c6a4aa4f1927aaa64fb06f0839d20df7312256f0c80b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad855df87252e54a39c5435a4e7fa62b1f46814fd9644c64cdadbbb75f57414"
    sha256 cellar: :any_skip_relocation, sonoma:         "de2f5389ce20f4d12237eac73826579515df129a597aea556d1efa8f2b88a12e"
    sha256 cellar: :any_skip_relocation, ventura:        "567b8e5631b3896b4ea322592e68f855756f7e72c24bea628fafd70748d6fe85"
    sha256 cellar: :any_skip_relocation, monterey:       "5cadb54391142d9ffd508caa31b61a6dc335d17ce2a7e98a5dae14424803c8f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9a97d5417bce1dc8cd5535801fb0cd2bb4893b5f44815282ecda97f407e3fd"
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