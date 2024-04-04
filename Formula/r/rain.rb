class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.4.tar.gz"
  sha256 "90310e75341ea74acccaa201c04df928976e919e57deb51767682faccb991588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58f972eba705fd03087c1ed14554168767d3558585fbf54ed0de6f67adca80f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666c61e34aefeecb2ec7eccbd4454e13f41e8edeec1648c3b3c823e4ca38e535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b96985371aa735dc6936852cbe8851a3a055c64a7e72f397b0daeb171119f04a"
    sha256 cellar: :any_skip_relocation, sonoma:         "92da1379db2b0e376dc7369aee72ad1e46e1364bb1a871bd6645d4ba2521d6ea"
    sha256 cellar: :any_skip_relocation, ventura:        "eb9f505fabc477ba916a4fdb3c148a929ea1a41c7ad0d79071da79c5645e6296"
    sha256 cellar: :any_skip_relocation, monterey:       "818ab875520bc23ae776f08945909f97df8d16a222654f1e7df73070c6f8393f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7e3323fb413f081c9d8667228e61b7d59140af7e00a11a2109c7cd1902c062"
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