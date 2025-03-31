class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https:huggingface.codocstext-embeddings-inferencequick_tour"
  url "https:github.comhuggingfacetext-embeddings-inferencearchiverefstagsv1.6.1.tar.gz"
  sha256 "8a24e1b2d5fdc579edb4aae0de25aff58d158aa3e5f6e8a9d36a003361a79c19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47307a332190f9916f0e0cef44ae0c121bb831521cf9b3eaea4c4b19a6d3f2b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0e114f66cfc66d971932cd1d05fb1f2b5ac567f396a9b2703a19894e125436"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ac52d206adf73d7524ddd2dea95d9bb5dbabb36a3c0e6b319249123a2e28b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "27611f04b051a224d23ec2900578b9bd0b77f978924f03b957cdcce43b2b41e6"
    sha256 cellar: :any_skip_relocation, ventura:       "7af64fc35e917019777c8bd793e150d48c7920c90286fa8a88b15c5fac44755a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e8ca8ccdb536b67241628c5901395407d58b8aaeda6841519bb59b66b6d8be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5419379ed0041789ecf91ee501c408989c7dc41699f7fe3eac166965f33c2ae1"
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