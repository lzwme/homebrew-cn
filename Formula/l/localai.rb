class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.5.6.tar.gz"
  sha256 "9f972fd48639c616b721f67a8b5b43c9fc5daa384d97b7ea7c522da35c367675"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "113df3dfd9b98a4d1e0cd07a11b1f36e700124d0f58b503bfdbb79651d17a0e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af2c531e35c583d6bb9de4a14354dc1236244ed9121480ee838d1016d3d24fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7734de5dc6e86dfa852aa6989a3bcb5657c4599ff930a4ca720db4f89aa013f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "342c4a8c1fad1a8f9f9456332725a1b0e8c76b0bae1a03f2d3af1a3b338c968f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e55637e4de12c2c111fb05a36fd5c6b2801c8b03a08fa499245762b31fbef01"
    sha256 cellar: :any,                 x86_64_linux:  "6f2bb5de595d6f3b9564a3762cc6c6c4ec6fe9eeab5e8a2e9eae03a28746615d"
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