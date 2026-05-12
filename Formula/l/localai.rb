class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "380d9db879f3c973ffc0d1efd9e8bb503299ade8479ee72b9a6419b1e99378cf"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45d085bc3fa63dd51c3dc7b63a511f2954f11cc0057ccfeeeaaf4ad309fb4f5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e35b7a747b1d3a1573f76e5c06ebf2f5b1f518e2d3919a88c8e12bea397573d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "805c55a9a0274861e932d2fa07cbd830219b5b2290d4a262f51b6950b4ceac08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca429e83f0c3cbc7655a71e76b3342910dd4456c95a870973e501a25c2864c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e911df77f1097888870e817edf5f0f63f1904719d858fa4b9973fa2079ca6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c910b735d49133f924fe731d5fde9994466a46b500e7441bfbbb49ea0bc3120b"
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