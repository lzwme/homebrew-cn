class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https:github.comprojectdiscoveryasnmap"
  url "https:github.comprojectdiscoveryasnmaparchiverefstagsv1.0.6.tar.gz"
  sha256 "a11b7262134b959347b8bb3e380e8788d1fb07d5a0c31860f7053a96e4134612"
  license "MIT"
  head "https:github.comprojectdiscoveryasnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d584d116081a7064acc68e52693045a494032bfc51c42d8b80c05063fa64ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c051624c0d8aab30fd9ff384ea7ffb1a645d8c04579b49b085586849c746086"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "598ba2103f7cb3b295e38725893390fe73e3088386639ffcdf6eb5912e557e71"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c5137a3353a681dd04fdca643f859521a09d4bc1c943e5244af194af17008f"
    sha256 cellar: :any_skip_relocation, ventura:        "7c0208b8f4b8bc508849fb9bfa0a221336efd5aa112ab0035ba425696089be2d"
    sha256 cellar: :any_skip_relocation, monterey:       "31226ca6a4a5decf96c4245183f91aeb96cbca8b843a41500f2c78a95a38fcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e515aab2b535554c861cb31d29b507ad883a108f37ff442ab6c1854e3921370a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdasnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asnmap -version 2>&1")
    assert_match "1.1.1.024", shell_output("#{bin}asnmap -i 1.1.1.1")
  end
end