class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://ghproxy.com/https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "3ec7fcdc52e5e354d855ac57a846c8aed6c33e2a441564fa1ae25fc1f044eee8"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9125d0c16451501426e7321fb643168a2b81dbea58b254a68e92f87eafbb64b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53294b4f0f8f5e244d32d903be7b0f8a42fc751c6679fa003a8fa6d83ed2fc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3469cf464217677bb2664d90504389e4107c270583ef5716cfa3f633b4832a59"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cd20f30366ca2a711f08888bf6562220ef58215939076aa64ad432067b3915c"
    sha256 cellar: :any_skip_relocation, ventura:        "32e1517d36dace511bbb64aba2380cd4164d32c9a7cd98fb7c4bae1e87cdc97f"
    sha256 cellar: :any_skip_relocation, monterey:       "316fd9ce444ad192a13a73cad2ec4f247bb33212c0f0cd8bdb8f983ca136bdbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2c2f26a3cd1ab05f870268a4380371c69ec3d9806bebf3ca126b5ab988313c"
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