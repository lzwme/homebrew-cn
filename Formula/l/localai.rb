class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "9352b6f64b847585be311eb7a82e080ca6bb21447255eb9889d5e2c8eac77973"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf5262871aa8cf62581fd79ef0982e38763a1b649d73f618d7aceb224f64740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "839b1a63a3d36d266b86ccb341e2a58e11d5275b9ae9b9c0d77be5837149c189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a42f09264b95eeeacb2b6f423160f756b513afb7a53a337035fa0769c617c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b847b20d9f662d747a31c8e859e6baca62ca3f577827f82982bc995678d09144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb21999e3b43e529f59b971593aa98d2b4b372f8127790d9633a90b9d0d2b4c"
    sha256 cellar: :any,                 x86_64_linux:  "23f59f9868284548710be31fae662f5a8e47d0858348903351742f32f8f18505"
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