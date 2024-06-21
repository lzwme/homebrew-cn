class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.11.0.tar.gz"
  sha256 "703f06e0c0aadcff560c745b96a012c82c27da2ea486c85893efdceea79cdd13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9d2faab8971261155abfb4076ea47f34b2b56753f93cf0051bb47fe35ffa209"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aef7a1c5cb513ec273b8f2a147f4e4dea6ff82c45ca2ffc59cbb43a44cbe3362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea6c3b50f46624548ef02d4c17358cb5a3d756adf88252531271900f1cde498"
    sha256 cellar: :any_skip_relocation, sonoma:         "01a845b48dd23de63ac53fa28582b24875d2bdadccf8f69128ff07faa774fed4"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ecf27e8088de10f694b65060f6f4ce135c283ca86501bdb89df98aa58600e4"
    sha256 cellar: :any_skip_relocation, monterey:       "6b25e417a6cd362276316ef84a4996e8ef6e0e1217d288bc39349a06da28c7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838bf1ef83e3152d4d0a83e75004a47d0ac46147d1a5b776bcdafcda705c89db"
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