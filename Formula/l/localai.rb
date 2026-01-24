class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "18f225b0b11973787b9352d0077cb903ddf6fe399ac48ca28dc9ac10353d30d1"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d9a5b16287cf7b4f8151b89a033ab4d68f3a2b096ab659bbad433796c070055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55632358a5c9cf2526f167f88e488b19be07a66aaa4bdd6722e6cb73fbf096c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d604efeabe60ee9effc8ac6754e03329dbc221a9e590be3bf76c219a726116"
    sha256 cellar: :any_skip_relocation, sonoma:        "5459ef2c74b732fc305178d68835737f426b0a0395235e8623614d6f3ba11fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c4fc80e5b6ad85c20c6bf51d7ff646b67c8faf27ec8c1a12721a63cbacd4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69139fcd63ecb049ee2cc4ea48dceb813e23e1200dbd3daca8f1f3e1eb436657"
  end

  depends_on "go" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end