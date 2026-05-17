class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "0ad68ebf8eda9eb848645c815a9bc827f29c7bf51f191070470e96e2c80565f0"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b13b720801e3a410457bf4a4cd2e7f90515670e2a6850171c46f294a4397784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40cbfe36fe8300f9de3d3f36291980a83a6721794c855ae41c35d42e7c9f0ef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ca3862d8d97258475d6a65f687110a06a48c9a844e173e1278e513aa98372e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c6983b76f7392315a500b945d009b23a9a181ac09ed127cd34fc0db7483bedf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020ca056a9b6e59e8a3fc171efc148460860c3edaf09a2c3415bf4d98a36e530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca6e74d5990c507b0d1c06676b5721883e9a11fcfd8f9e72f89a2ff18bed82b"
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