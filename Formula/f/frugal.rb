class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/refs/tags/v3.17.4.tar.gz"
  sha256 "97f5d29dd6eeddd1abcf79b3e1a47472290b5b4bd72e2dd730bc5b997272c10d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ff85c292ae0abe4e96dc6aca4d3b04bfb3131b8fb664087bb18374c1bc4f73c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86440a6e2c5e629033e99a110506266193c6eb1efbb685d8ac4e4c4a6bbabceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a95a85472b8638df61b52a2ec875c0280085d78d7d0581f45eed90c516f731"
    sha256 cellar: :any_skip_relocation, sonoma:         "15f1a36c3e5b14dbad700ebbf579051b1b8ba5e26848a4f8f14d55f8b07746c1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b23fb5060b2d09b37b6f819395dad9e4571221f48245787354340847f5d0868"
    sha256 cellar: :any_skip_relocation, monterey:       "3e07599136e1e67b6895edff3f6b74264738e7f735272621ec73ab5fc13c7096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37ab4fe92607076a6e3b6853de4dee1e61002088b45577fc0922330c6ff79fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end