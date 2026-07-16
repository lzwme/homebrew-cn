class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.4.tar.gz"
  sha256 "399aea108d542c87547a1ca755e44933d8b6de7e05a82905a859488158c23a23"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fa8f2ae0d1a6a659ccb18b2a5df7ecd01a1c065f486af88a6160e3fa760ec33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac02b204ded00f7798a4da9d05b03560acea4d63d3e027e75a5e8c85d025418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "408385f913c7edb2ccca8b32f38ce07f601321f0235d7de7a42c68af7077cc65"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4137b90f5ca334759c5760517f9af89ad63ed665a10b660e830832a51d7e365"
    sha256 cellar: :any,                 arm64_linux:   "4e97b1e583478c47a22e9812fdb23f702d2e8a5ba1c7c33808e4e85a23c725db"
    sha256 cellar: :any,                 x86_64_linux:  "c1e9696323acaf16ad15710280a033a27f77407e60a6954479621fb628cdbdf9"
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