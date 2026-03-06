class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.6.tar.gz"
  sha256 "d4a5000c905ef7a150137e6fd93a2c454544ac5575bbc25a6cd89e41619cccfc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87568b99ca94ac5d90637a254d887e67d740d1f0c316a7265bf07db6cf7b0202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c67ac1a017021d7e01ad14b41d154fe8339c5336c6fb057d40e136ed3609b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0127bd55a449d6b6690839bb6e516b5f97268e4691eeba4728ff84f61158e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f0d41f9a0c482680e6420f5ce0ff90c2c35c45d507e43e79aa03a9e1377b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd7389884ba17071a0abd35d6576f3d0af4ee647452718c94f8249661717ab64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23459597927a85c35f165a7ee196e60b981a5a354eaf27369988827002a70ee"
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