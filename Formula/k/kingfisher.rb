class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "d72a73148e7b8b59818224564927cf7c246ad1a5c6d25f151f97adc0e606bb44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc5b0a8c8b278c611041a2fa8e212d1d31a83adacdd17f8694e35d7a1da73323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5af37172a6d8c8c2975048aeda7afafc15862fe088c5c44d411fab08e37e675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "591eae6ca378eab5153d0c9450e72cdc62f3fa4c160069ae4fc2ad4b61e4cfc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c109e9f6d2ea0c51f4bd4c90204dea48e338b9b6f691c19d4f129bc7ccc4c6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d828780a17da8326b7e8a5779f32c9ca3ea5e2bcec0e0ebd969c2b2eef984b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e21a1ac85bb058a744e8e8b6ab217b3c2153d704787284b8917538e2b87cfa"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end