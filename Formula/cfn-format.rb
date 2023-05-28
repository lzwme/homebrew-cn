class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://ghproxy.com/https://github.com/aws-cloudformation/rain/archive/v1.4.0.tar.gz"
  sha256 "3dd05a6bb4c08193fe9ffad2d99c4d06cf205e7a0e31d64655a76ebdbbbc29e6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317e5401532d5dd9b1ec577d5f763692e6496825d4fde7c067d7ffc9b7892137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "317e5401532d5dd9b1ec577d5f763692e6496825d4fde7c067d7ffc9b7892137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "317e5401532d5dd9b1ec577d5f763692e6496825d4fde7c067d7ffc9b7892137"
    sha256 cellar: :any_skip_relocation, ventura:        "b8e2ea3df2b5e5373b3ca253926cb189d7b9232d1c39bcbd45690b6851f5fd07"
    sha256 cellar: :any_skip_relocation, monterey:       "b8e2ea3df2b5e5373b3ca253926cb189d7b9232d1c39bcbd45690b6851f5fd07"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8e2ea3df2b5e5373b3ca253926cb189d7b9232d1c39bcbd45690b6851f5fd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fca7cf63b3528c2166f5caa0c4a7a688a3107117c89853019faed406d7bfa94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end