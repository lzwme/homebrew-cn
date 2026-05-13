class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "fa7b3e1c1f464fb681272698a546ccdb06f16f51e38bfaa8b6223dfa82378d25"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f92815a94062cfcbfa29399d5605df1ec4bb5a80ed6bdbf223f54964924ec5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e50382089d3703e77808c26ccd9991e7d12c81ffcf3fee32e51e556531a8708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600e35afe29f2ea19fc8749beb418da92e251ecaf7537ee3c06a53a727925e77"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76f434066361acef91e4c5777b1a1c8ddc79407419bebbde86033ef7655617a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0df5aa722a86e79e30f41869456e7c093e3d59e876b41b95bbe722a902d63f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152274564d70d810199f5bdbd33db922af788a0f08d1bca1849f2725b52f8061"
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