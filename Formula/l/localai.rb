class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "200b8275fe179cb3faa60f8ba34155002d3ffebcf21ee8d1e7e7567ceae6c869"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4d1d65b2389972c1245242318cd8f186079c683a2772fc5b9c941261b1bc9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b82e5103318ecbc3de7acc3e741edcd80a39d6e75ea2fcdb366c380bfe1431cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d53b22682c00b9e222d4c637bd7acf19f869e36957cb9d6c5d3b62dbfeaf4311"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecdeee114383207b7d55e25f864ad75eb2a1e2e092965277dc0d7e8a74370c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eed1811243803131fc26e282a1914f7fee4b5c0a7fa65e028ba77fc60e52ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed9a5fa50d9d1e51de7eb3dbcdf3427929c36e890aec3c91b6a1b9f80527c2a"
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