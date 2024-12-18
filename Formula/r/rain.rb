class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.1.tar.gz"
  sha256 "04cddedbe35074e66fa1683dacf9dc5cbb3913bcccaf9ba7a587936b2bce928b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42b58dc455fd6f07dc4ea2151f8440986247ebad79ff121ed2b47de444aff45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f0248719a9b6ffd40332e40ebb1220ec23222c18d199b9f0c41bbc35c3556a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64f0a01ad835d939edc3296ae39f403a27271732d08b5d78308e74324d88170e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba2c57cefde01ada775f4703ba61dd87084f87fc284c87ad8f213171713ce246"
    sha256 cellar: :any_skip_relocation, ventura:       "481708ed367260df51c41a19ad0c182a22d6bcf50f275b4d3556de87064443ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e682a0f0b2b46aa01c72f82126b52bbe2e566d5b060e66e8a05cbeeef106f7"
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