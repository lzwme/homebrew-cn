class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.2.tar.gz"
  sha256 "e26eb1c3444e0e3934e2ec90967126061962ff792fa16f5a50c16a0982a386af"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2e7fb1d3396512c7addedf42e1715fe2a562cd89d9c6acc920c9a6786232e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b67cb5a4a0672cc97fd93b5ffb5a32322820a7dbf282689d68bd9ace8a3e6e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b65ab3b8cda340a21313cedc9c92883424d9638672c99318cc87d285d7e8eab5"
    sha256 cellar: :any_skip_relocation, sonoma:        "13402534c43b17dd626a3acb4863760fca2267abe11ec82bf06fda75beaaecb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab27fbc5981fcc9b9a7980850e750e02facd7edc5b23f2cdbafeecb9a404332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8109970609dc868de8d16d917df714e521c4b997b4abbdaad7042a32e9dfd063"
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