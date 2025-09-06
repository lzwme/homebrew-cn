class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://ghfast.top/https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "abc40dc953db356f01b0bb2f163465514b9fed92a2c6473b70de25e3c4da8acb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16164f90175bc132448be18ce9bbbb4ad21c489e06df3d009ad600d838d32f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57de3f7e1c2c6aa7cedb0f1dbf9c988bbcdc248d3ff3c0e12c7ae28c58501ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4315b712c32620de9594813bff3c5c5cf40015d9cf7d4f4c05c27b9233d7d425"
    sha256 cellar: :any_skip_relocation, sonoma:        "629390d49a9b303a799b44d5f79dd3baa131ed7ae4d973f695a515f7d1316d47"
    sha256 cellar: :any_skip_relocation, ventura:       "f06ef6d75e4a69a29a2e0e089e1d5c9fd80e5181a0fc1c1c91f746fcdba95516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69af5f8c2d5e6d168152d6daddb6a167b27e9778010c578315448e246a856fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a40ea1103b0dc08cbdbbdb64b318f890663bf6873d06f0a081e4a99bf8c52f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    args = (OS.mac? && Hardware::CPU.arm?) ? ["-F", "metal"] : []
    system "cargo", "install", *std_cargo_args(path: "router"), "-F", "candle", *args
  end

  test do
    port = free_port
    spawn bin/"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformers/all-MiniLM-L6-v2"

    sleep 2 if OS.mac? && Hardware::CPU.intel?

    data = "{\"inputs\":\"What is Deep Learning?\"}"
    header = "Content-Type: application/json"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}/embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end