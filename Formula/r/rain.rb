class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.13.1.tar.gz"
  sha256 "97cabab71ed9aa1eb77203c8419856d52a0443b317014a698b152ee3b0385b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02fdd8bb06a93d574700374eb63a43b3d3990636851f6bf2c93076958a7afc88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbdb40b44250ce28f28606599584cc11f7212686b7dfd1cea39a135c57890706"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964ce0778765a15b3af7e1371fb6f15d6fad8acd90d3298834a9742b46e50821"
    sha256 cellar: :any_skip_relocation, sonoma:         "088a315d9e4b55cf304093960127382e5cf0894e9787a843e7ece14af8f03d74"
    sha256 cellar: :any_skip_relocation, ventura:        "7c270e9fd1e83a4540a11030985df013c61b1555801fbcce6080f9490a151c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "388fc1b077b27370b078f4f396a5411f5544b8ad8184078990bc431d6ae25e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6e176dfbf8b38a6e5dd0d16f2eb7069183e8a18c35e88ce1162f24dc34272c"
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