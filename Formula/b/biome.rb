class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.3.tar.gz"
  sha256 "620a3ee8c715ba373e9b2dcfe71af67e1175e80c3216682c29585fc2de8b69f9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6c4e3bc43a2a867783d08d8d6d7e87ddf488040c9d0fe5dc5cea9283917ec9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37a684736f6cfbe99ff9f12c8ee8b18aaa9181bcf6c74f3ca3288ec952b19d51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea48ccdfee8b3af54fe3ba0ecf258d6f80de892e6917c835320ca30af51c49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ccc87f94d5ad90ecdfa8f25242e1102c70defc07f8ad720ff3ecce90f56037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69c6cf7da1f6f62ac93a7eaa0b9f71420777cffe1aa37cafcce1596aa7048ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c9f7cc1e8d6ed16b0d19bc52f1be8e882a78bec4e82c12936a481eb5eb8937b"
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