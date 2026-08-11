class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "1f8f1e93d7fe65bf25dee7c1827819db98723392aa0186cb308e7a087f27ea66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4172b31efa252d9a290ff8f31469115142c8fc3f54b161a16e384feb22458a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dfdfb60a1cd5a24fd9e0b821dabde6887569805bbf1697d5202eb781bec525a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc464a2595e0a1582d25fe0cfde879aca76473442bab06e870b4fc3f56c592f"
    sha256 cellar: :any_skip_relocation, sonoma:        "17aa4de38901e374b1b4e0fad906febccd3276ca9449ce9f041de0fccaf9935c"
    sha256 cellar: :any,                 arm64_linux:   "b9c5fe511d65c2e580825abd2a3b7ccb313436e798f0372c33fad17d02e7e1e5"
    sha256 cellar: :any,                 x86_64_linux:  "62b09bba97beb83affc61a9940a31e96eab33f60810e43d6350a65916271f4d1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end