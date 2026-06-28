class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v4.5.5.tar.gz"
  sha256 "709c5bfc6096c677a02d2ae5db6f0016d91a5f236b0f811fbbcb169ed8f54c53"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5acfdf932e621594944377e3f102e9feb401267d7a72f59cdcf58636e639f29d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66b5b7f3dcd8932d39c56983eb292a851a8942e7b1a5eb9600b0c797338600f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f58306f68668cf6670378cc859a20fb43752896bddc42e5bee7ac83ef4115a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bcdbbcc23efc8e7920ba4b8f63de3473a040cb61d2e418fe9aa7f0dedec57c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08fbf53b4b4a03379078f7b6f3f6fdc4b298b3bc63cb7ffee5bdd42667f7a5ea"
    sha256 cellar: :any,                 x86_64_linux:  "9bd0d702cc5835a9bfe167f2688e0439d667961262f68f902a7478eca52da052"
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