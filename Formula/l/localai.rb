class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "d81bf2b830176186ae5b1392138634f0b04f4a17f748efa5e8fc1aaf7a69ca33"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "267958dac9dae1474d85eb3fffab9f0db72f39a36713886213598fc40704e0ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c15646fc8874e9d6e1e71de17daecf85c4cf431e855101b5df2b6a6d55e014e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293f3eec4e5d5fecf55675195a6541d7a230c1cd51aacc74ba2002d07408b082"
    sha256 cellar: :any_skip_relocation, sonoma:        "d47d08904f72c390a25a6d0745a8d886e5c6cc93621d24b387dc0733fa0f67f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591692b10a7f32cf1bff7d3ce52a5ae59327885514ff89890f9c915f3b406630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2b84ac4e65ac99924e7d8a6eab76dce93ee582102ee33504e6feb0df061d6c5"
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