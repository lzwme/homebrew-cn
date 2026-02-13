class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.15.tar.gz"
  sha256 "ba117dc1e095592921909899eb036ecf801941c1b7adba7d0de2defea1d2a955"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0320827c0874fe004677a1d00f430b0d2fe6b1da1388da9737592f0aae6293b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dc995f80c5ea1b078707627a52d2b8b9e35fd47ff005be4012d4343cd708d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0336fd1d7128072fde0e2336443c69734a1d472a204acf88d879f8623fac7739"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b350a2155a42a979c49f37a916dc01fbe4e1b1a12b89191317f068449953ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07bb43a110b8db994188e965e47b5a8308de01167680526ad967738c14cee397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4aa5fcf5d031ba35d7e9a7410cfaea4930e3fed4ee1f4e645bfea654aba6d8c"
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