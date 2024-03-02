class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.0.tar.gz"
  sha256 "93539723e544db865f99e65afcdd4f53b4d7ec7e99a283cf652619145901c165"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90e26db59b89d38e21417e37fda9cf5df0a932c3f4a68eb48f889359f4c75e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5cf8d0434a79d707a6b97d1b2d74db3ee8bbdf2b455b5e18a95c765a3047519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec00cf57620a09d0757031d1597a5b34b3ced1f5ecc9b6a7aad2a87092854c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "efb069996badc75a74ca6fa4cd3145851b526a4f8890ad177e9f71568579575f"
    sha256 cellar: :any_skip_relocation, ventura:        "dfafa8d020be9f16486c8703347b480b506f2ff9cfdd59fe3ce45feae70342fc"
    sha256 cellar: :any_skip_relocation, monterey:       "78d4b2bd81ff26d78bcbb633b8632d3ee20e30e3d68db5a11b94d09aa722486a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdefb5546ed80f9564cbf5903a0152666a3a8d61d82da976a4f955d051dbf936"
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