class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.11.0.tar.gz"
  sha256 "703f06e0c0aadcff560c745b96a012c82c27da2ea486c85893efdceea79cdd13"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ffcc22344a1cd2f1da8bbe1e054aa0469a16ca4cc4944fd33d0c9fc34664692"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2128802c6c1605a109fc81aae1970e7139f5b9fb0a0ba728427c39af77787b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0767a40d379a5e21d1ffa87214602734f09429aca45f59dd049a04ed09d3df1"
    sha256 cellar: :any_skip_relocation, sonoma:         "676e45921be28045ebdfa481c2deda62ea2e07af5da84b61a885d7ed2eec67fa"
    sha256 cellar: :any_skip_relocation, ventura:        "e2a11f7777a2630ae603f2647300d67fed05ad17b3bdeca4e976b27d8a21b37b"
    sha256 cellar: :any_skip_relocation, monterey:       "4afd282dba1cdb1c1e3590447d535e07e0abf5502b3471c5d92ffdc2636bb2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99df58502c7512d92e254c9f21e0d6c677b40727c4f1d508594eb7372a9305c1"
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