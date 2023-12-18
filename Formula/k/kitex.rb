class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.8.0.tar.gz"
  sha256 "8527e418b4cae64a48d0b4fb7616eb45ee9e0bff2ac12f9e75256a605fe5f7b7"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "246bed522383afea4c44f5d3efcdd1c1a541ff5a33b74426ac14802e76419d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc1fab01c84da7c2847391ce546442039229279f768cd2409bf8724d46f39cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cafd6e12649b247128957fa1631b1673e7d6b1ac225dcf0ab1f2ff2d70d33f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "71175bdd6a8069bb9586ee9ddfbe0ab8627b43e2ccad78acfdfa871e8b7fdac8"
    sha256 cellar: :any_skip_relocation, ventura:        "480c38b9720b9a80212282eccbbc271e53305811b5bb32726e2f54e51049e206"
    sha256 cellar: :any_skip_relocation, monterey:       "48b4a78b7ba53e87aa9158383bfb47fc9c94aea941b0de8fcf0b2519f0e678d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fce7e40486971063b4784b2066a4f6a7b46eac5c13f18792ed28e965f7afbfa"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".toolcmdkitex"
  end

  test do
    output = shell_output("#{bin}kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system "#{bin}kitex", "-module", "test", "test.thrift"
    assert_predicate testpath"go.mod", :exist?
    refute_predicate (testpath"go.mod").size, :zero?
    assert_predicate testpath"kitex_gen""api""test.go", :exist?
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end