class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "66d54356c68432860032f5ae429a5844e09ddf09cfd9f8385957418c866e854d"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f9621a6de88ca96d2254fef495049c5dbed7f93600aa143e2d0b73f67193eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925bd382c4262aea2dc9f8fc2b89549852a25ecedb6a204c3a9b5042812a424f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a60da01126693fc327474f583d7cff5ea0cb8d1c6c2cba705f3c8f1e24152ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "0016392005870242677dc270f307662b41a5ebc1226585349064c9787cdc81b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d8d857a1b1cb9dbd445c656e72097d27f23468a8a613339acda9d25568ca492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8fac817184988cb7d0e3cda06a81e6003035fedaa52e7a390f8d7c3cc5ed68"
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