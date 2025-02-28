class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.12.3.tar.gz"
  sha256 "0a7592fd2cd1fcbdf100a8e304b46c184a6cabd89ec9ef481cdde0b2a7b34e63"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f52547f9dfdaad1f5d1804e551f0316ee577fb164d6d39d719f1b790991e741e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f52547f9dfdaad1f5d1804e551f0316ee577fb164d6d39d719f1b790991e741e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f52547f9dfdaad1f5d1804e551f0316ee577fb164d6d39d719f1b790991e741e"
    sha256 cellar: :any_skip_relocation, sonoma:        "516863eb7bae6233ef85c2b150457af1bc36814b60a238cc6421d88b5fd07eaa"
    sha256 cellar: :any_skip_relocation, ventura:       "516863eb7bae6233ef85c2b150457af1bc36814b60a238cc6421d88b5fd07eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3353ca803ea7e000230dff63c8413be74871fedc5c0c8a59d28e720ef8bc3fa3"
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