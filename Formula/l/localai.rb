class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "4d8b7a5b551ce9c3f27b60eeb599e1501d3a5e210da50f2d8fe1f1a06caf272d"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eac29820c6b833965cb52e46cb0b007ae32f734f20ee048a80d89036b1d0e811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f26009a3adfd71f97218acf84c57ac8f95d3f82d957db2d0c7e32213c01416d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5eac63c94c99780b096c2d3450dda9245fec8939adc6cc012545a9b3e4927f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "093bcf2a5285265183ec3a0b4bcac25ed931320525ae3cda5aacd624a50c2359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf4b5f78c2d83bf784a8ad19b13b9bcb454cfd9cf3184944b32d54a6db7ee59"
    sha256 cellar: :any,                 x86_64_linux:  "8fe80f74fe8216dc7f1817e2feec883d780a597a452c3a53852b0668dc376e08"
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