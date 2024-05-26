class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.9.0.tar.gz"
  sha256 "657b6c5c83774592faf69a52750378b64ffdde7ca883798a85bd01ee7c83a3fe"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d99a1a3cc2ea861c7380d833aa7d46d44edfb21a9038cf89aa02869e0ebb3e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c714b4188cc029912399c53713c7f74baf1744fc10640fff69e0ea829e248985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23823780c5897e06e773125c2135857c9824128c56adc0c7c64f67e924277cd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ce17c1d024d49ef097ba8d254a8d10eb2428317300e118aad827a3465199594"
    sha256 cellar: :any_skip_relocation, ventura:        "06bfe9e95df4014b44986238d19354c6393eff9b068d4a5c3e890b9730b807e7"
    sha256 cellar: :any_skip_relocation, monterey:       "ee85feb5c9c538a521d9d080dc12b7f291c58a8a5f996e5290d8b1a6f40f5bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303902852ae3cc6db48385457cafb396c8eab0405c77baaafe88cd7cac03b3a2"
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