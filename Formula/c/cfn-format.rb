class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.12.1.tar.gz"
  sha256 "53f3f412cca548c10b85e49958fb1bd43c065b1d3658500b2fadaf1dadd2edb9"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdcb5fca9648649423b3b1fefb869fb59cd6244a005552117c1a7236ddacb557"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9753e23a0d54b92b281ca1376e21d66965d45eb54b78697d688010c7fa83939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f8e1f791e099dd4e5bc628ad3ee40afe2417d03674e650d80a10b400978247"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd4f5fae39e9315b5d9b737d3cf63be6562747c25b0dc27b99d0e5a0e75a5229"
    sha256 cellar: :any_skip_relocation, ventura:        "4cac8b5a6ea092596308bc4a5ea1e00d64870015f0dad6ecfd466c394a9ee45d"
    sha256 cellar: :any_skip_relocation, monterey:       "c31efe73bf2d04c5232f61c692bb4ce16e4bd1a3f2576e366e1fb3793817ed73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4df1002d3f47b597f3da28822489a4dcc50b721777b600e23b94596ee8cf93"
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