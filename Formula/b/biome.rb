class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.1.2.tar.gz"
  sha256 "867644b04ee7bb10c82dfa78e48d2d8e8d9ab28dadaebcc00cdc27930f09f445"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc540f48299f1396dcd00b29f5c64dc43dc30cb4f69bb7d3b539d5b85d2fada7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09fc14c4bdc2879aaad65fb14dc108090ae842f1540ad52138b88cc2c0365543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e83ec73fc18f471cc900ff999b77d91bf27604cd328001fd94a4c0136e179f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8cb35fb99fab72dcdc5dbc6c846789c5b4220a446cf3a2c8e29d3971b55924"
    sha256 cellar: :any_skip_relocation, ventura:       "6de83f4f5f57989c83890f6b91d07691a408200b4826d083ee58ff2b20073539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851d7cd245d1a30b56d82d247046d0790808752e402ed906808d54b7eb1811ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7cdc9799e5d76af812d5f1f73e14f20dcfee7bc303f538f02311765f08e23c"
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