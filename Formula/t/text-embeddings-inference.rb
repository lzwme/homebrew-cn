class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https:huggingface.codocstext-embeddings-inferencequick_tour"
  url "https:github.comhuggingfacetext-embeddings-inferencearchiverefstagsv1.7.3.tar.gz"
  sha256 "64842ec3ed0b87663a628c493dede0cc62ca0377b387562c5db4d68287d4dd7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2919c3e2cb726ef7d456fa9da2d54f01cdf21038097966a6aef715f21c1f6910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d73b0d7898967c0d914b49cd9e31f7f09cc47293f75f301d3bd288ac7a9256"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5c8a909007715e7d83f0ce029cfe40d96836c3d0137f3d4a7d583b7098e39f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4f95c2380e2d4a2e384d2bed5853e2c3d253324092cd87bb7c81f7f56029a9"
    sha256 cellar: :any_skip_relocation, ventura:       "3cd4c7514c0f1753658f8faac07c54822e3192da829e1e4e7ad7556e52fbd74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae5be686347c6904b9e10932c3515da2aec483eb29501ccd5fd0a0795dab145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010ae6c7bee386589d7f93d3df456a69143d84a09b4dc814f07e04e1079fb700"
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