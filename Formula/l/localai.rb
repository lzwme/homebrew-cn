class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "1d0c3ad6b5ff48e1d31de598bc4c00036c259f6decdb743c41040d4c9d638537"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cf2792170ec47236a05bd928a47cddd799e33ee24da5c28b4c28ffcd8ecb270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6422b7276b643400b1347008b9ac35598236b560963f08e4533c1d20e04c0490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112695f4ec6c57681a04494b25ef212b5462a6e5773c005056b3d8c576742ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa051b77befda3331ad549abab2497f6ac7f33d187dff17274509a33a17bbefd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d897753e6afdfad2a49cdf67bf6006e03ffb6888bff79c2bea195e708f2b92a8"
    sha256 cellar: :any,                 x86_64_linux:  "04895b9785288b2b2fc93358166047133ea207a5b77e2a9e123b2708fec8dadf"
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