class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "60c5697ddbe453cb6095deca0b36bbc8af82f8067bbf361da373573e6f92e561"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e650997a8610a1baaddf27309b6c3337086b8df78ed638314cbff4b0fcbd1979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5a5dd081f50b11ab34b49eb867e8daaaffe16c99aa9ebd19e3b19db3a1269c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c7f0acf9707ae6ac968eec1b50dc827ca9fec107832cb9464a045fbc444cc8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbbb5f8ffc537197b85d88ac13fbc134a687ff535076405270ca04b9a2c35642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1de6f7f4cac50426f5b76a2de79ceea8d430ec9f56aa8ea324468f1b2f2a7596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7b3671879bf02842a4771922075e77bb5cd72e1377f1bf4b36f059c7cf5487"
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