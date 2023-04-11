class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghproxy.com/https://github.com/cloudwego/kitex/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2d1872e490a0c8a72000d9cf7ae179501fff1228ab17c2dcdf648009c2b06810"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c0ed45b1e2bd827097d9c34e94432c703e18159225d259cb875fa00aec877c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c0ed45b1e2bd827097d9c34e94432c703e18159225d259cb875fa00aec877c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c0ed45b1e2bd827097d9c34e94432c703e18159225d259cb875fa00aec877c6"
    sha256 cellar: :any_skip_relocation, ventura:        "62031a7b9a74ab1412a5730d98646f00a53469c6a3849fd7a58351ed993d9232"
    sha256 cellar: :any_skip_relocation, monterey:       "62031a7b9a74ab1412a5730d98646f00a53469c6a3849fd7a58351ed993d9232"
    sha256 cellar: :any_skip_relocation, big_sur:        "62031a7b9a74ab1412a5730d98646f00a53469c6a3849fd7a58351ed993d9232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e990f5544d36f4b3a7a607e93a014e6ece1c59758578f584bc5ff9084ca0f798"
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