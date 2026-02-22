class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.4.tar.gz"
  sha256 "d1f330bbcebf2cdecb1f39d23e3739bcd61a1cda35fad36640cfcc9d55214aaf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0a88bc5881ed0ec65ecec89c6b5e5f10d04acbc298b386d35e38a875f62be8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37373f4ee3d1598bda4fec177e3a2858408297f61adc2e500ac087f53068ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48125bf9c74c4afbe5fa62b8ea54b0f70cda40ce5b6f61ad118810fe42c85d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "2279d5a0de1eeecbc06ef34c466ef8c4fe3de62cf2bcaf594f2c508b9cb22f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87fbbaad1f88fb0afa020e6e99f429a97a051b47c4cbf21d03c8bf4f2c4f9607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cce7ec426bbbbd84d134dbe5dd7b3b4f438cd26e304ef8d72755ec965cb6467"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end