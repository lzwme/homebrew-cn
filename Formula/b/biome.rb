class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.0.tar.gz"
  sha256 "333c8bc8fde72520c76809574489233736ec3f27f85676350e930d649fddaee9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884c53c1e038e6fc90950dbc745e98cf13bf75ed788ce0fcc3a763509ab17235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c35c6ac9a85dfb9a99add71d515210234ee38eec37238d4fb2a556bca0d5722d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1351935476cb1a0820788ac5362bb3490c2dd9fe483d3ef868f7b503566911a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "80e3a5e669badf397eba764aca513749210fe2fcd3eafab71ccf3de8d47de1b5"
    sha256 cellar: :any_skip_relocation, ventura:       "746b7359e69f7777a7906dde6f447fba9be27886737d7eb9b4ba1a51aa6eac30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a6a3e425627ea9c997643329f6d6a8a356cd25e90d4ff8352ffdede9897bcb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb06a923ba6e2d84028e0da1bca8a6b58321d8dd3a444b03d72d1d75d5ccfea5"
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