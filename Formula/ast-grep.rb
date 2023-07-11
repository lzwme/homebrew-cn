class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.8.0.tar.gz"
  sha256 "1b22f515efcdbe92a1291539ab068aba1ffd4e61d8fa4d24efbb73c86deb05b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e83cb5e461267a075a707b9790863598206e44712b1b21c826f345c61878f0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e133afec478395bd16cff7f7890d3d08cc18d832f6e6879609d4503b3c72aa8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89dfa265e9d6bcf4c4c79d7b96e7781094b3c0074fa5ccfc3110c3aa085ff02c"
    sha256 cellar: :any_skip_relocation, ventura:        "8abc1aacef7277ba308e684ec8b8356bc176f0d08a0ddc9d6c3a0ebfef93d73b"
    sha256 cellar: :any_skip_relocation, monterey:       "109a960e9704f65a75f090f1d4fa70fbf451c810842533d9d8a341ec3bc8f9e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7676217ce845727ebacf7bc484e118d5792df72d603f9ba5c4946dfdfdbcd9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dcef98734448a0d4b58f82135c5f2f6d4d7417aed89458c2ef60f79bb1ddce7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end