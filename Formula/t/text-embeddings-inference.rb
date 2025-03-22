class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https:huggingface.codocstext-embeddings-inferencequick_tour"
  url "https:github.comhuggingfacetext-embeddings-inferencearchiverefstagsv1.6.0.tar.gz"
  sha256 "e044ba139ab30dc539fc20a0917a95b1ebc07f643c3684f9482c3acd60b7ca3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f75d6c5c85a806ed3e6e47db32f9cd213875d4b7fe8d5851344893a137431f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8ca71b1c4b415669bb771dca194c5d7b0daa76924f50634518488e095d793f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c976cc410db127ef601b3397c5826d0acc8e53c7bf3e237c06180fd0597daaaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b445097577a9d20a873a82d77a81d4c77b6f813fc0c104d2f9f05fcaec4ac32c"
    sha256 cellar: :any_skip_relocation, ventura:       "9c43e0ed2d9bfdb81964e5774c80e35945ac44ab7b0226cfa0ce00f8b15b98be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774e11dfef5db7d16af3ad53f98974c71a1797047b5ddc91b56c9bfec385fa09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c5f2c92887c5b924de74dc1aaab1c23471edc102cd724a0ef116719396993f"
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