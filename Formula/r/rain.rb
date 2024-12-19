class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.2.tar.gz"
  sha256 "b899bc4dcf05b6254fad411e87d8eec6dc4681b84d89f48ba789b5833266ec99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f23e9b078bf0ca35c57852524f4e331e1822053cbeacf7736d874199a84a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894452f9469ca9d28716fc249c51711d4ade5834cc136306eb7b76d92b797272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0a7c73392d539c94877d13061279a10659ee1e065d8c4039919869ab2294255"
    sha256 cellar: :any_skip_relocation, sonoma:        "a81e40b7b8637d15ba03c1a2188bab55ae9acae96f1ee22712f902d98d7024b6"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed1a26a42c7d8f1da8b49d48e4accfd24ca7f93930ab4e51bee9031ddb35469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f5e0ae9f61118f8c37350ee154e55273852dd9a9be5f7fe0f00a03835ac7cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdrain"

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