class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.97.0.tar.gz"
  sha256 "90a69a4223e9f4d2f69cc98308812e98fabd79cff003ca7f2a9f17997dd1f7a9"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18cc8bb1cdbff88fd1ed22a699652d168bf4becda419c829dc86e489ea32b16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8cb53b5041a3a51f8cd7a0cc668268ab6fcc8d54f1710257831b98835f5dc2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246ecba6b989d436e085b005e39ee5d59125b6b398a8c13e5b85e777edceff3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7e1e7e57a0e16a1a68f861f7d508fbc58a8e5fd8c0c82449dfeaba9e081dadf"
    sha256 cellar: :any,                 arm64_linux:   "e1adc728c8b16fffb459c276f55483430b3327c744d6e0cb2a709403c2dc5fdc"
    sha256 cellar: :any,                 x86_64_linux:  "6e3ea0a0f1ed69a1e4bfb0ab8ece3da9bf25df93bcaf2f23a6a8825c5ea6a076"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end