class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a56e6039b4b3fa1a0171b8fa0f65a93644f415b1fb30ec8b31c1095ac674dcb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b78d538f599439d452326c5783dd5e416b8c0862d49837e8759ab50c465ad4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af994fcfde9e87474dc02738821034f2d2b1f5ab0459860ef6b12666f9307b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6dfbd39da89fc034a04fcdc7410cd54fc863e219cfcb3aeabd6a7c73c54f24d"
    sha256 cellar: :any_skip_relocation, sonoma:         "19d3d3c24a7461804c58db5bc50d8a2a8425549094b47d49301140ee4cfa684c"
    sha256 cellar: :any_skip_relocation, ventura:        "b6fa0c6da5ecd1b60f0062369482ca5fec86654542fe4bf57d67e6a6c01f00cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6d2bdf1e31f12bbbba58d32eac4687d5530b5076810346b2266b7e5a1ba16890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643b12b0639fa59ac241326c9eafe3352004450eead59f05a3be86522fdea15b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/rain/main.go"
    bash_completion.install "docs/bash_completion.sh"
    zsh_completion.install "docs/zsh_completion.sh"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/rain fmt -v test.template").strip
  end
end