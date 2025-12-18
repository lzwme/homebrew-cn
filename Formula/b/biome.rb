class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.10.tar.gz"
  sha256 "319fc6a46ef05486cc7c419f9467a83b25a75b79f0409ef2c40f81684aa934e2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a707400ba78aaf21044a0f38be3aff644f88615ac3e8d32ef4415f5af4410b75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1dcc3067b5c8ffb78ef287bb527fa05ff1b6900f8aa562c19ff2bbf8a11f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "717a65e8f792fbae458241f686d0d533731320bb192fbeca38fbbbf216bbfc2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e630784f697103bb238c9bd186f344b25c30ce1c52ec8a0ccb459991025c460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3adc0d40bb16a6802bd28aeeced2f7271dfcb58950a705a10ad8f6f193203346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07fdb9c18b2359fdfea1be16645e3e3145fb013100e233f3b29be1dd7e0344ad"
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