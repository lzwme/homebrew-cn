class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.1.4.tar.gz"
  sha256 "4700c0d0fc95f6ea7d053d5efabde79d2cb4e7dc2f600da2e97f3f1ec8b18a92"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a2c3dcdbab623d49d03c62750ce5ebd8fba92a4712a90192767af84c726a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a996e42b78885b3951272e23f42055ff0eb77d825edabc318cda6a2fc04130d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8405904f7c8af1cbf1465a5fbab730697431e630215d068737f31b11efa80c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "80eeb17b016c92311953faa2f850ae4d43ed10d69434a85d0e463844b0da3297"
    sha256 cellar: :any_skip_relocation, ventura:       "1c346a8d9d03564da9361d861ae08eccf6d31df58d82ae716622495ef830b148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03b8d08c5fd163f3b3064e7070fce44be1c3469ab828353855a40dc41906fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d5c3803c6207e49aca67a75266f94949f82497128d27f8a483b1c1ed9748d9"
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