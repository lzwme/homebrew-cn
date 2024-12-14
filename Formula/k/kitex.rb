class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.12.0.tar.gz"
  sha256 "fb0f526ffc9de885b0ed9a2c7cebb393b36edb14a84957601e70b7ef9a5a520a"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fcc9bbe785091e70e04967cbce1e905da82fc4fc08d19ae5765ddcd5557be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fcc9bbe785091e70e04967cbce1e905da82fc4fc08d19ae5765ddcd5557be6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1fcc9bbe785091e70e04967cbce1e905da82fc4fc08d19ae5765ddcd5557be6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2755d1d972460e1dd07e8928c0da59627eef991c91a9ce6a99b8cd8bdf20ba8"
    sha256 cellar: :any_skip_relocation, ventura:       "a2755d1d972460e1dd07e8928c0da59627eef991c91a9ce6a99b8cd8bdf20ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5fc62625712942280f619b58cdc45f5403f5b0e9936dd5a59ca02ffe8bea69b"
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
    assert_predicate testpath"go.mod", :exist?
    refute_predicate (testpath"go.mod").size, :zero?
    assert_predicate testpath"kitex_gen""api""test.go", :exist?
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end