class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.5.tar.gz"
  sha256 "8adca7056ae906613eba31a607b1a8e4dce3696bcf7630064ce626154a8d7414"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40702a92fe8d56d80fd9f12ee5a0492e7bb8b7cc15bdb110a01dd919495e929a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe875f65dd1a0ba4f3394cb58489326d1faea1a36b59538270e54ccfc50a61d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1551036e30b4bf86906eaa350a05d66c858eb4d78c07bb82bc67352f8ffd5ba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "806b1090849128fb296de21f451434cfe4ffb4824f609b32954802d6363a20a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b5c0b86c68f771729d5043f65504ca061805972e72350d0132d2b5f226fee6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b177bf4582bdac0c87c7ebed95235a58a43723c27c74b65c58140a5602be6e"
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