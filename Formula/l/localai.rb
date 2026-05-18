class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.6.tar.gz"
  sha256 "13e0474f4456ff0b965f5498b5baf2eb4cd6885aa58c21c71486ba858ae1f24f"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c539917a3388172630ac0f86093c6509514d1de8339040823c8b64aa36ab2d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19713e28d2a789ca3f02fa78084ed318686295d93f36c7fa6449758cfaa72e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415e87e5658a339d37334efd8de71c03998773b8ba0856ab39bed1e83a70dae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "064754084329974f013f389f44bd2cc88966342442d08ff20702eeef36ddfaf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c71b1aed0c35eb53bff3878c61d6ca4f78c860b84faa7f61150b71a6e298c8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7dd299c1f6a6b39366007fad4dc66fbb174bae1e528c2d8561bd559d717d9ae"
  end

  depends_on "go" => :build
  depends_on "node" => :build
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