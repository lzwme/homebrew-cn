class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.0.tar.gz"
  sha256 "40e9230c94e21b7bfe5288f1d4add3b3ee8a2e442a89650f8066d39a8c8b4f53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d7eaaa2a5032f5146ce9ad4702f0906120566a4cf9fdd7ef3a38f75a763862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee24dce1bd95e6284222401aea652c7a1165d5c7e31884762c717af1f3d96653"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acff80edca5cebec93f8dc2f90ac3fba681c744ad1715a00268293e538bb9f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "454ae0b7d8d5377cdbad743e99d316ebd5d6bd5b09059b3d573bb61674957bdf"
    sha256 cellar: :any_skip_relocation, ventura:       "1185811912440fc9b50cc7c3d4c018529d227f7784f4d85d1680cd48dd156abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6977df4e3a1e9fb6cb0c0cedf6ef0e1758902dcd16adad8da7b5287c4856db21"
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