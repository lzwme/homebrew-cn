class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.0.tar.gz"
  sha256 "908d0370aabb4053c57853f5226a4d6865562db974df8b3ac624325b1006a435"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ffd5e3739ef71ea4e3db6af692cacbef20dc8edb6be45fd6d2df14d972e3cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86b3082b1c86687feddd7a54c30b2d650e10da1a0f857d868c461444da70a919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9b54cc5ff4c2868b3246081cca312dc2aeda8e16db51076050d8a5c008b7407"
    sha256 cellar: :any_skip_relocation, sonoma:         "f25395a00f2f1d1448eda3165099ea99d418f27f184e52cbd750d4fcd509e234"
    sha256 cellar: :any_skip_relocation, ventura:        "19de636e7a985dda99c0e15236841914276858ff2f68486b6c8be0b1a402ce3b"
    sha256 cellar: :any_skip_relocation, monterey:       "053a9dfe58f61d7ed340cc172dc87a468b47cb745cce18764d39251faf4527e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c53b0907b689854800c37975e55f6ada252fea8881c293b60a808134efe655"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdcfn-formatmain.go"
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end