class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "040109437e4ab330f8711214e24adf29a7374ec3d8b2f7814588b8a73ab158e3"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c1f217e4b1396a89e87c33ce6fb1a030bd74cb77d4d023a2a986d844a222094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bdea520ae901faee9aec32356fb2d726ff69ac408ebeaed35b5429fe77b02e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6596bc2be3dc65462381730e640b05622cd3b539b5c8b1a63bca4e9cbd368f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb1863490bef1ef485cb0755d9afaef4c2a522e3d82b6d55c242ec878f65963c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d87df8e3c55d1f205e55e2a28dd831a013f127c27f0131fad0645373b0adbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf901a155de46c78bb0034562c5676bf8a5de6e849d1d7adaf149750cdc006cb"
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