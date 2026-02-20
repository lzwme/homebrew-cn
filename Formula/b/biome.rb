class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.3.tar.gz"
  sha256 "26e3025d629b1de01cd6abf45565a2348991f0e185191096b36b2aa06816487e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "929e9851181c2843231ef0b0e5e8ddcb557fef797179316daf0ad82d24992169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b1084bb757dd6634713b1c82d8dbf21c0d324a0a601abe4aff23ca1db4b5be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f5a4f07270dbb48ed8013ac9b1282fb59d562f3f95c998280512fca3092d6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "10c2de3e0cc2608a97b7b7fdbf5f098e7e5cfcc7a4f15cb63b21539ce9fdea4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "089accfa26e801682b3bc0792fe1dc7583265c1e70c4c54993fd82b46ea972e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63de0249a5d38c1e4aa597829b2fb782c0611fbcf1b5e2d9fef0e3810a2237fe"
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