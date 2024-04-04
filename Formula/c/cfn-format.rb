class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.4.tar.gz"
  sha256 "90310e75341ea74acccaa201c04df928976e919e57deb51767682faccb991588"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25d439f3ce853b3920d3b79666c9a2087135d76da05ebf044fd8ac92fdf4e971"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b8d759686f8dccbacfb9df125b1c0b134505816b507b05dd2ed1e5ebd8478b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01341c5ff71f262e11b54d97a4cde2f3f1204b9b63320572394f3dd1effc97cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea97c45913e367c9e0be6bd8f0f4f0230db2dab1b4fa87d246b8f066008e66de"
    sha256 cellar: :any_skip_relocation, ventura:        "c3c86ca0a349c511fd2b97f1bde967f5d62f7114e7f09be6f49779b51bdd865c"
    sha256 cellar: :any_skip_relocation, monterey:       "3bc045cb93048e0f39adb387c69fe8e70f0bae17aa59634d6c8e8046e351aceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978c641e30151efa32839029d4762f321ea5a2c15586c4b73d3c46b8b037fdf2"
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