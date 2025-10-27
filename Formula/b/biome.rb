class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.1.tar.gz"
  sha256 "83ac4aeffcd1b3017ed145c92565ebe0fb6a61cfbd9005f4f1c732c1232df035"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a57ca3c85e53d04ea40f8e4b84b2a7199959872a366395e79576cfbf89bb6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978fa3e6cefd643b09864e7753cf17d998a96f59884f53ba2daf38bca928ac05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e1ba39e7603d8929cf232fe5b27761a623c8ae00626034343f6c071ff6aae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f987e068be4acb2bfe94fd67c12cc2f6ad2876061d6aea6a1778f97f0d244f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c2ba8fc15edbb590b1cf182c5043e5b0f5e37b9ab26127ef8af32c5191787a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c083dadd20ec499af6648f444adc9a805d6b2d77a8542c0f0d09b4a25625d495"
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