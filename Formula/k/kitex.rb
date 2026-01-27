class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghfast.top/https://github.com/cloudwego/kitex/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d3bdf06906f1aa02e975c64d09fff5e1579db66e6b9933b36fffd682eb711b2c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb113d42a7986fab49fee981c2a7df0f41159398240c6c825af21269be67dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb113d42a7986fab49fee981c2a7df0f41159398240c6c825af21269be67dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eb113d42a7986fab49fee981c2a7df0f41159398240c6c825af21269be67dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ad2932d4886c8f984d033ee4d4d819a3c71bc97a30dcaa6af3c307a62f5322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da1fc73c3807a1f968a10d7d5e6a67d816149c9d5d540da79f0f052489b4803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c6aada369c3dd8cd52719bebfcba2154ad3d536b64c4d66c2acd88d501b748"
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
    system bin/"kitex", "-module", "test", "test.thrift"
    assert_path_exists testpath/"go.mod"
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_path_exists testpath/"kitex_gen/api/test.go"
    refute_predicate (testpath/"kitex_gen/api/test.go").size, :zero?
  end
end