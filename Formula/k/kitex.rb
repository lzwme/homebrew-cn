class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.12.2.tar.gz"
  sha256 "8ad488e9bea6da87b323260d7f3eb988b85068f30570b5dd4f3d989f3d229f01"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0e590149dd7537b55c37a69143aa90b8b2458a1158c7fbb06a560acac239ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0e590149dd7537b55c37a69143aa90b8b2458a1158c7fbb06a560acac239ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af0e590149dd7537b55c37a69143aa90b8b2458a1158c7fbb06a560acac239ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb62c83f40dafe4954b3cb837beb12303d93824e799535753581fa72455bcabf"
    sha256 cellar: :any_skip_relocation, ventura:       "bb62c83f40dafe4954b3cb837beb12303d93824e799535753581fa72455bcabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07ee81f1a1dfcaf26ab91f6781a915499f1ffb4448cf422f61e0918eb39ad97"
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
    system bin"kitex", "-module", "test", "test.thrift"
    assert_path_exists testpath"go.mod"
    refute_predicate (testpath"go.mod").size, :zero?
    assert_path_exists testpath"kitex_gen""api""test.go"
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end