class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.0.tar.gz"
  sha256 "908d0370aabb4053c57853f5226a4d6865562db974df8b3ac624325b1006a435"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baa5d161f2775f4471848090a9b9b096ae3153514a095e72ea4f878c0794caf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5f1918d8f73b07fdfe2c5bd1169e5c8266e861a28326bbec608f0d9b0b76684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fce7b4f003e5d280ebca10714a8cd4286039739dbf038ea72fd82fed2f5e20"
    sha256 cellar: :any_skip_relocation, sonoma:         "2200b2a53161eb933d5c10f608cec594de20041dc1e7c0436b65c54d092726d4"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0bb2543745571117fe83734485f076c93bcb1aa31d5e1dbb808254ccefaca4"
    sha256 cellar: :any_skip_relocation, monterey:       "88ccfa6859c3aa130f2bf68cd1bfbb6c6bf4a80890339a80bec6a320de7b251c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aab8ce4ff8cefc5ca8ede774263bf6f64f6eecb574e9e9c9f95f6bc529204382"
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