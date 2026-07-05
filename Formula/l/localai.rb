class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "ebe91d24eb00fd4089eee0885694831ff7d2878b502955d4a194c384eeaff11b"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55fd1f5f626f4c3fc74b773cce151ac2c542530db3b5d59c3bb190acb7e91d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c80536d9feb687ec7f8ef4b52118b1876134c3a7e9fe49112abab33b1568038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5faff7bcd909f99f3d5c1ae90c6829cb9c0d7765946adc30d5544b696de13b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c353eb0f931c008772ee5314b7170c898042fe0e000f5e4864ecce93d8351553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd242105080aaec9de9df98f1c531b998a8fe5213f4a11c57914b7ff1e60092"
    sha256 cellar: :any,                 x86_64_linux:  "199ee404dc1971fb5a057b6439062f8de67fac861e9786ad94ccfe20ad2694c2"
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