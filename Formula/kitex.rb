class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghproxy.com/https://github.com/cloudwego/kitex/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "7115e15e8ad351b9b4da650a838471f5f45f2ab35b5720c41d5e07f959311b5b"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa6226bdb849edea6ed4b643c0fc9368985762e28f4361f07d526be16c986520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6226bdb849edea6ed4b643c0fc9368985762e28f4361f07d526be16c986520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa6226bdb849edea6ed4b643c0fc9368985762e28f4361f07d526be16c986520"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9db9e751bd801a8cbfa6ddda3f5981f7b7b37ee35c364d642c18c031722bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9db9e751bd801a8cbfa6ddda3f5981f7b7b37ee35c364d642c18c031722bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf9db9e751bd801a8cbfa6ddda3f5981f7b7b37ee35c364d642c18c031722bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8726b98843facae7518d823005ef5bc44ec3caac75eb3bd0875e2bd63edf75a"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tool/cmd/kitex"
  end

  test do
    output = shell_output("#{bin}/kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath/"test.thrift"
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
    system "#{bin}/kitex", "-module", "test", "test.thrift"
    assert_predicate testpath/"go.mod", :exist?
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_predicate testpath/"kitex_gen"/"api"/"test.go", :exist?
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end