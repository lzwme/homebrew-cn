class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "ea9024dc0d04cc39d08d0552d0b8ed123408c576c823bfb85be2c2c3bf7f416a"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06a88371de0f28ffd69f0f3bf06bc4baf003867452f875b23406f7fcbe806587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f68ad71ad7625066370808739ef534bc5a4bdadc5cce129303b63335ef88a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "453ce52e74bdd022342024df81369246924f6835203896e2be2181f1088a2dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8de2b4ab87a9ab5b637164de67364ef5bba951065a03e72346e1ba646daefe93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d9f594a7d783f8dcd635802742bf73853ef1b02ac0eb9b10bbb0a9caa6dd538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb3d203bf3aca281f7b08d89535bd3ebcafa3b36e99c81fad75ddf627b013e3"
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