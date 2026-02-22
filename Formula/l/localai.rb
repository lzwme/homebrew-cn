class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "318ea314b31afce1858d30a52f8a8c16212e95e7a395d1b49e967af8ddfd8af7"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab43749b5afd0fc2da53017f3342c82808cc22823b7481010590f88e96f4bd62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "161004e89f1737405afe3f8fba9937ba9c9a54bb7627f6402db2990ce79f4870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46870bdf9581d21af0fad1571569077b2f72efad26c564d29a691c9a5f735c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f14c2fc950e8b9ae45146a384441693c590de1afb8526680a43b5116ef1f380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf44155ecdd0217d282cf5f14b655eed413ab663eff611c3540d0fb636e37ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab6236bdc7fd350c37f68e2c822ecaee639bceb0a463ed4510ffeef0f557143"
  end

  depends_on "go" => :build
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