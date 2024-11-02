class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.19.0.tar.gz"
  sha256 "6cd3dd2466d5a4db2fb8d2043482a77290eed727ec84cc2d532f7cb1abd3cab3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aaa22065927b47340852392c682fb2891284f8acfc9acab153da5489ba1513d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672d69fa258dfc8aeac57584c0fd4951c965d793a9f80942659404123c86e8da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1428e079488494516b35d2176713cddc565de6bea23aee3dcfda807d0255f35b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee151a63b3d07bc3eea77e3a434c1a41f900260646aa7b657d2cc81929028c0"
    sha256 cellar: :any_skip_relocation, ventura:       "5d904e5d03b165e106119bce4923e935661ac83bb615a37aabcee9b0fa6231ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed122de0ed205d625603b841a38ab741f6c3a475d99dce15ff0334371bb2e510"
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