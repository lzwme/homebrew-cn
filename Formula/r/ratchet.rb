class Ratchet < Formula
  desc "Tool for securing CICD workflows with version pinning"
  homepage "https:github.comsethvargoratchet"
  url "https:github.comsethvargoratchetarchiverefstagsv0.8.8.tar.gz"
  sha256 "e8ff69c46499cc343b11b4a16a028f1fdefae1482c07a4a88443643fdb62e154"
  license "Apache-2.0"
  head "https:github.comsethvargoratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b20e997995a622e325645a5defcd99a81e428ef397e81daf0991fbcac8cd025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72f3b9fba1023548f33ebd881e1aa618e46fc51fc9a4fae19eedc69fdeb7879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ea4275b86024129da2cfb0fc5b6ca1bcbe0b56e3bc9326f51e98f0531d454c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d8219e32853000bb9515c00ab3abb8135d45fa57579e5f78b34ebb1ec84494e"
    sha256 cellar: :any_skip_relocation, ventura:        "77eb90699c598ccfc07c1e51d7da9a4fc40f32d0638da5e3fd3a1549342aa056"
    sha256 cellar: :any_skip_relocation, monterey:       "b209d434a042bb01d898a5ce70607e1c29200e149bea00582758eb28f753a523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07f2c2941ed28a924de27cd526262dca3579fe91571e979aa1817fe8a036842"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare"testdata", testpath
    output = shell_output(bin"ratchet check testdatagithub.yml 2>&1", 1)
    assert_match "found 4 unpinned refs", output
  end
end