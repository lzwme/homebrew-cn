class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https:huggingface.codocstext-embeddings-inferencequick_tour"
  url "https:github.comhuggingfacetext-embeddings-inferencearchiverefstagsv1.7.2.tar.gz"
  sha256 "1b6c877419662f0ddd287d917b71790a1812d4ffd6feb916718e475842fee4a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4727076a3db9929e02657cfbbf87e0e555c24ff09b95997aa22bf5b3a43a3d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "183d2ea9f481025729eb51e41b4e8e49bda146056371155a0920b19379800b4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "702753cd4a85148e74fc0be94ffa461d0f0110e9d2ceb0f6e4f47c651036d389"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1cbda9d82981729804d0236236167ea1d6c6ed27b3ba617ad7bc60a5711feaa"
    sha256 cellar: :any_skip_relocation, ventura:       "502025bdca2b091196270daa7550cfed7ffb333a3e5ea323bd39c1f47b7b1807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2861ab865c14b2873dc78f8afefaccb78039a15efe6e2caf6ee6874519c5c701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a307aac6aadbc2df5a808f90841c643f42546c27c52de874a3fc0e6e67b8689"
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