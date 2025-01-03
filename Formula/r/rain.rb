class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.2.tar.gz"
  sha256 "b899bc4dcf05b6254fad411e87d8eec6dc4681b84d89f48ba789b5833266ec99"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fab2fe3bf19e53cf47b35e20de4dfb14048d2b6f52a742396437af4c1375535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd83efc3f08a367485662f3ab8534c6d4a9ccf461cb498c8d4a2c16a5a4a491"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c88ad6843cac01f9638d0234dd3f199a2e19dd49a80e50e38520b16edb5044a"
    sha256 cellar: :any_skip_relocation, sonoma:        "757dae67102a70496f24a2e48d1e3ea77f382aaae32fda9c19f06c7c3500baa7"
    sha256 cellar: :any_skip_relocation, ventura:       "9ecdee2848a66ee24f9ec2c554fa71b34784cca0c9c11dcbbc375a357fe9cdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e0ab13f70e98a3bb02dbbc8ad4511f714d888121e085a3c82f17301592df9b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdrain"

    bash_completion.install "docsbash_completion.sh" => "rain"
    zsh_completion.install "docszsh_completion.sh" => "_rain"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath"test.yaml").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.yaml: formatted OK", shell_output("#{bin}rain fmt -v test.yaml").strip
  end
end