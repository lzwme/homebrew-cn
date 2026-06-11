class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "6e46685a00122226794cb1ed65a8940ea5f600a2e11914525baf3769f404218f"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2d2de7e16d258473d335f0edbfe0c8adadc27239d9955fb9e4ad2ce4040f2d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01bdcc8ef179cd7e88e81f2ccbb2c9584db8d2e00cabb3546cd47842ea195732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2aaebcd6d8626deefa0d6eb3dc712e12707f67a79ea3252fa5258a8d57fb7d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5c2364cdfd43a3c6ab2494b64b1ff4200fe3cc4e07bb6fe11c7ed93bcf8a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca1583d338a40517d5573d8a9eed17f13380409c62675d278f9c118d45a66bf"
    sha256 cellar: :any,                 x86_64_linux:  "875650a995baf4dd9fb6fb7aa44d6221181b5b081ad7d177258eff3f884c8e5c"
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