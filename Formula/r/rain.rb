class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.15.0.tar.gz"
  sha256 "72239387e6f6890b9e7e701e61584c72365b4a65abf87b3d103f9aad5a08e9f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42a8c58c803fc50fb26d6014af558910f52dbd991aa8140535bb9b7a77eb5200"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f366e083d0bc4a4ef754ad7cf5191c6f0719abc46e4b6b1c46a895b4550880a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da5bd4e7ae7e5473e8562c435fe830c697e01d66a42f1ca60a475ec60b7fb9a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "beecee4c5e51c4b1ab66f5f333a4e76e14488f0c75727c918875fa53675ba7d1"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc4cbfa26a73eb0fde130a3d49cc6a1d7f38e9411f689937342c4a079524935"
    sha256 cellar: :any_skip_relocation, monterey:       "a234480f21d9a0afe2f04c83bf10689e06c6abc5d15b8e86c89d70bd9bd70114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1154beef69eaad93e59624ac50510117a920b914003a22dc0c9c3b1c8df1eb0a"
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