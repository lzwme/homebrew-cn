class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "4246defb1e003b3ab152d656a349a3887b65aa8c6585e8b9fd9e67b74e8bffb9"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb177d8c6a3a02adfb91462cfb042d7ec4db52b1e840efbd92aac2991862f574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101ade6ffe9c0d24237d782856ce8f98ba70350697550691503e37677bf54f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2beff8018ec5afad8653e50a1dd50bb033ee6c590a9e8702d601a1c64c399ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b629fb07b4aa2026683694dcd99deaec323b4e31a6b583e3069a5ca2ac160c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac2821fbd8c85fd37181cab8101f7b6ee649f9c5c5200fbd70ec02936faa36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035bdb55927ef0c0102fb72074c3ee3cb97c1e0cb4cee0c2d8e05d0fc018a597"
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