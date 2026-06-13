class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.0.tar.gz"
  sha256 "cecd17d03fb36a7724cef692f027c6dca61090fcb5f029386372b70b355e2beb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a01ad5b16711fc7ff9e64841d05ff4d0db3fe78166d6c87e6938fc81c52ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7cbe3bcd1a677f99c8cf0286261c3680b9af31b7da2255c3a5c5dd8d30e676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01777139f8e63ca2918d42b6910aa914f55f229ff2a6b7ea7a855bd9ad598b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa2e93ebb7de13b1a4d2f09b6b5e410489b636bc224b2a915c7a957774bb583"
    sha256 cellar: :any,                 arm64_linux:   "a6c67a48934f712102972f02478eb26161a5056e315400fedb1f0cf7ef250f52"
    sha256 cellar: :any,                 x86_64_linux:  "99bbd7d7a8f5a4fcde9f73716597553198cf865992df7de34002edc873f9058e"
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