class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.15.0.tar.gz"
  sha256 "72239387e6f6890b9e7e701e61584c72365b4a65abf87b3d103f9aad5a08e9f3"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "01852e0de71f29d665ef1029a183939c8e29ed667874985528aaa65d62dfbcb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cdf7fd5ee9b949f78ac6936194bd9babb805717aa6b97108ab3f1544f530441"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cdf7fd5ee9b949f78ac6936194bd9babb805717aa6b97108ab3f1544f530441"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cdf7fd5ee9b949f78ac6936194bd9babb805717aa6b97108ab3f1544f530441"
    sha256 cellar: :any_skip_relocation, sonoma:         "56599cef2080f3c568903230a7a9b61a916369b55ef9eddf39e45db61997ceed"
    sha256 cellar: :any_skip_relocation, ventura:        "56599cef2080f3c568903230a7a9b61a916369b55ef9eddf39e45db61997ceed"
    sha256 cellar: :any_skip_relocation, monterey:       "56599cef2080f3c568903230a7a9b61a916369b55ef9eddf39e45db61997ceed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a0c45d5d392e32a8c6d100f789be5485cbd0de1704f7a701adb54a98b6fc05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdcfn-formatmain.go"
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end