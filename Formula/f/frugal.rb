class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https:github.comWorkivafrugal"
  url "https:github.comWorkivafrugalarchiverefstagsv3.17.11.tar.gz"
  sha256 "b1b945968d1071a7314546062feaba4c5c14e9261b805122217309155c8922d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9a3d6c402a80a9624095847ec42c91a38c24f006265fa6715689e326ce0245a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a3d6c402a80a9624095847ec42c91a38c24f006265fa6715689e326ce0245a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a3d6c402a80a9624095847ec42c91a38c24f006265fa6715689e326ce0245a"
    sha256 cellar: :any_skip_relocation, sonoma:         "27348b5b4ef6c0de77053298e6bbc163a2371381e1e19e099fa03651a854e569"
    sha256 cellar: :any_skip_relocation, ventura:        "27348b5b4ef6c0de77053298e6bbc163a2371381e1e19e099fa03651a854e569"
    sha256 cellar: :any_skip_relocation, monterey:       "27348b5b4ef6c0de77053298e6bbc163a2371381e1e19e099fa03651a854e569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7deafe8abf3f8e2a5a3349e47f3bc7bfdb55588fc62acd99c4be41b8502e4280"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"test.frugal").write("typedef double Test")
    system "#{bin}frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath"gen-gotestf_types.go").read
  end
end