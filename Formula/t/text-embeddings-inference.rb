class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https:huggingface.codocstext-embeddings-inferencequick_tour"
  url "https:github.comhuggingfacetext-embeddings-inferencearchiverefstagsv1.7.1.tar.gz"
  sha256 "f13ca40ec88c633c9c70e093b3fdbd070ec25475e72ee6eefdbb3f80ec08e767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd991dc030d260b56a105bc0ca4c10c3d799f82808da500a0733ac07f8807bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9444bc5be90598becfc835e6bb7a18c7f9f8527e74bbc643d839557e1cb0ef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "991cae61c60f0a11b27f57379fa01ebce3c79b0a70da4aaf6a43b9874559171c"
    sha256 cellar: :any_skip_relocation, sonoma:        "158804dc222f57a24836c1d3b20e9d584fd3d296e58fb2986be866229ac26ede"
    sha256 cellar: :any_skip_relocation, ventura:       "b5da583421fecf126cfadf2b78d3d6ed48f110163d0f70b5e92f2a22be7c6c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b51deebc75811f3dcd592a430a054ec8610cef5ae97a8feaec9816237ea0b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1f72b07d67b3ad006d9177d0512964f20e7a1055325e611aa3cf3842ef112c"
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
    fork do
      exec bin"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformersall-MiniLM-L6-v2"
    end

    data = "{\"inputs\":\"What is Deep Learning?\"}"
    header = "Content-Type: applicationjson"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end