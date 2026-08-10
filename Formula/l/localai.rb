class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/releases/download/v4.8.2/LocalAI-v4.8.2-source.tar.gz"
  sha256 "e8bc6b0b0670f9847fcc4ee275565bb2c48eeb697d49e41c97d4104f3a3c807f"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db3a2f4b3769bd96c93bb00ed441d62eba24e038759d2e7a69bca874a7fd966e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5fd411045141c1e451855b1d306041047ce902f0ae8997acc5dcee46adc4e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1aeb814480346b5b2ec00bdce64c53115f8ff7215312c14bc1114d241a77a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8262dd5be033aad70d7e9a0a69266e55f334b60a043de2d5faf6f9ea69a17ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc14f8bed6ae80d4f77db33e2bbfa22e10ce061f9d1df31fb342d52097c320a"
    sha256 cellar: :any,                 x86_64_linux:  "b488db27a7de0eafbbefbc8825a43504e6aaa3d814f43ca84d6acc43d5c0e495"
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