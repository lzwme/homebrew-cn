class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://ghproxy.com/https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "37548e6999ba4860ed22c0903e1f3d62b757409463607df8138c630308ba5c91"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d90a7ae16b0c6a774cf3931bee1e3d17727448dc34247b940b7c2d8acb417cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e0b92ac24fa19cf099d6d926f98596e553547e38cc2e1b50940a27aab12afe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a272d65897ff4b51fda4e73facb04a2e2599ba069556ed0f316d751bb5426b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f207f0d76215a30f97d5e074bf478d542337ef24d6232f9797f4295bf575cfd"
    sha256 cellar: :any_skip_relocation, ventura:        "0e4455e5778522b02b61c8e022f9e599249d8cd9a3ca668df48bfb8e9df7e645"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca8a6b04434252f6ca0b59f54030d0adf2c9f98a934d0bba81314ebbd4c1b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3e6e2d1424317819cfeecf52b16ca7c96a5499a52fe22257317459f29c1033"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

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
    system "#{bin}/thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end