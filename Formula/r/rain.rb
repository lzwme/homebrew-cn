class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.18.0.tar.gz"
  sha256 "b742cfbbb89740f4633fc9811dce9bac2d91612b9c9384d07439152f5af29daa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07861d59a5a7f3068d5af8b115f5989316d28881f34056011cb35377ce0adea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "746c7098911d7ef1622558e15d7417dde92a0705ff95afdd726e72964ffcc2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "482ed5343e7e9769c54d9ec01a27c27a1c02bb1c546639fb3d64ae2fb150249d"
    sha256 cellar: :any_skip_relocation, sonoma:        "357f6b3bad8aa45f97fd12db6d59ff628a15a488ecf070b263dca9be7d33cc40"
    sha256 cellar: :any_skip_relocation, ventura:       "c1d19407cc8bbc05a5f8925a068e4d6cf0e9bf88717756e298597ff9519df805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec2dc501c23b57c177876e1d2a35f080fa0786220dfc9872e087203ea9f000d"
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