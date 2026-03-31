class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.10.tar.gz"
  sha256 "95ce7203f4bc5452188fb90a84af593de4a15d5846930fa9afa390bdff0e97e7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c333df28b5781c8deda485cb13db8f5e1d30101cef2f4e63b281a439d04c708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8110e5409c251a10ab7ce24305914ab418c0c6fb50cfeea67db9ddbf3b4b454d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bccb9c961363eff27e65df7824e533d25940ab5163370bc4f4d12cdceda38091"
    sha256 cellar: :any_skip_relocation, sonoma:        "68deb677d67a8eef5edac51e1b83fa713d238dc0343d6fde12f2780a6bb40e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e42e616c3042a650f7d24985c755b1f2b546dddaa254a63247155c22861f5625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09bd686a650fc98b418d33cc7800764577a78bd8d196eb87e5b873d8c29d32e9"
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