class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.3.tar.gz"
  sha256 "6123e47df6dfb45991b5180925637137ed3cd5f901f77a3a7c8089f74ed31f31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24210ead357173e3d00b7951cdf62e8bf8d2c9591cb626197ed6a9789d3777db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d9948e5f1100065fe4aa61f81d0ef5737a3156960495076f461310a683c636"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030fb73bc9d06feff65314d6fe4c1044e53d75f1c12c660598be7dc0cff3d053"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ee29ef775b3c2c8e322d40f71fa6d1e9495a5fa488a3dd7168766a842cc6dd"
    sha256 cellar: :any_skip_relocation, ventura:       "32f9087f6a0728d1d608859ae08e4a73880f98f1f490f6412b24dc4703ced778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4115a543148c82995dea1ddb89f3a12958263843ad69e034f8a32857c4f6a314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0e0a6568284f4cad2998bdbd440e24b7fe80e8707625413fe440f35a6b08ee"
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