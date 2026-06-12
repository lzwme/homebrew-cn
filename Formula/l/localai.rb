class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "1a4d4b8f77a2f4c51d901c04f3d86cbb2e0cf07b245c60bc95431c9d94056fc8"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9cda65387bad9e382e7c613f03801bea2e8d67c1f5d5970a6f6b58aed9fe00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6dfdfecb4b4819a9281025daf88100709f698d15e158bdbe962cc3eea198f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ee4ebb07688cd07ad39af38fcef75f1f2fe84666e90c0bfa4755405de723e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ba149f1a0d2c88f64edfc0e96540451c685bb0e79d2fe5923b93f28a68fb67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36610cabe6568f58d6f68f093ef8d6bd35db7adceb3868de56c60b09c2df843c"
    sha256 cellar: :any,                 x86_64_linux:  "dc27f777667cebc3e37ada15b2bf414db0284c55c2501e6b55c827b62064b869"
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