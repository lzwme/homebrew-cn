class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.6.tar.gz"
  sha256 "0e033435cbc313278b67aeccbe7f7790f079fd312f039a6d1b651608d4115391"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c06fef1ff4c7987dbd5f7218630a47b7d086a8a20343eb4c2a5ca883c9d6a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb2e219f713b7a2c93c1a09e93e6137a5e8c99085ec94a6be4e8921d8bf1a573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bdb5dc6481a2b662ce861e72304801aed32f2715bc8040a8b3c137bd6ffdc13"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e513f02fbdcb8d859fc30adcf9a07e82d1d00766d2f87776289f4176857a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88c114c3b8b90d18368e7365687e39e9545801b5e94acb502391280cad66cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121d80021b39b6bc86f88945e4dc2556d49dbe9e0d9bd8c59c8dd2f56fdf3efb"
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