class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.2.tar.gz"
  sha256 "061a121dee041899be41d8c15b76fb973a54f7ab3fbfe734d744251476646b6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d430bf2fae8707f88046d83589f5d59c8da256fc6958099bf6cba8433d9ac9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82e022ee2eb6ce4c3616cfd73fc6d08db85a8134bd58be740a349c5b668a5220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b294e8fe06439d8d7ebcf004cca2d23b4d50068ee9a9c97e53c141ff6709eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9800edbc8cc63c70f244967d9c8956e46f0435fc9dd2c8589e1a9b92ac07e841"
    sha256 cellar: :any,                 arm64_linux:   "118d13da29a10cb224a7f080f3d5b91b1c25e69136d77c7e06168f5df9172d67"
    sha256 cellar: :any,                 x86_64_linux:  "ab46361b34bed6a221f971926f07bff8f66cc91c9d56f9d7619244cfb828025e"
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