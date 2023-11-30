class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://ghproxy.com/https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "561c05ea378876ad40b0eeb045de4eef91a64e8f9b7341071187962fdb712442"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4a4d6d415c55e01f669e5a9cc893ccc23d3ee94cc0a8453bd8d46df9fdd16db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e34e59fc65092c95ce81c6d76bf79eb22f8eacf145e334cf447ed89b2ddef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d0979419434b24da5e7cca6c3a9c600ff58c25c83e267aee58e50d5315b9c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "445b7274ea680b3ea13868c701f34269add02a651ba2b5dc60667c1fdd030ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "e155ae90a285b515a0028ba13600f2e9fd96fd531a162a734074d7f59ec9acd0"
    sha256 cellar: :any_skip_relocation, monterey:       "5d894cdbf363785ea432b1b57d2b59a0bca938f7218c68df7a1ecdc7e03677bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98f0a7a77535624bec92c025dfc038c794ef068cf070bfa22b8f086a2100dc78"
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