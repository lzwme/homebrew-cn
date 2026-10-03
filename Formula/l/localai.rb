class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/releases/download/v4.11.0/LocalAI-v4.11.0-source.tar.gz"
  sha256 "6002ee89d9674b3b7fe5cb4db0a9f5028d487469b906719db492053212b09522"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd8fb474425e7e395597c44adc015e331db03a3ee3afcc85ee8a4471344eddb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1178f1f84fa004820ef519611b3eeff91c71eda7443be4feff240e04efc9771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1cf9bbed4290f8a45419bf41e01c3cffbfbc41401f70959bbc3200b900d9cb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cacd46584af24c8ed3a0e8d5a9f2c05ef551bcbbc73ef34c7d65e5949c58af1"
    sha256 cellar: :any,                 x86_64_linux:      "4f1bad2770171dac4b604fc4357790ad201688d753567601909f66fecb46238a"
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

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end