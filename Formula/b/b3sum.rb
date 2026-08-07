class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://ghfast.top/https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.6.tar.gz"
  sha256 "da7b5b0b6cf7106fe54b7d718d1ea371cce434cd15ebe5e56ca011b645cbef0e"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ffed581e17ae878f7a77c33bacc115fd5d15e2ce0473a67c92d29e61e2c070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4d138df1ff4ab9e1f39794e517dc31cb76e058655485fc5aeda0a02ff340e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36a947f44080565d861affcbfdb234d0080e1e2cdb02cbc645520ca0572f4aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c679e5af5b4cf64d63eb383e4d15129497771cd1d8669f3968cf5e83661e88"
    sha256 cellar: :any,                 arm64_linux:   "9223e2d8e3f4b509f9a38735ae6926eb3eb2c0e8134cda1e36044514504cbe05"
    sha256 cellar: :any,                 x86_64_linux:  "dcc7cc0e850f930b956ffbd76a38e4cc6b53428f09179ee5964255293d86576a"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end