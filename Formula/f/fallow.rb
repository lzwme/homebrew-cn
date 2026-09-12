class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "b9b106320cda4481e4c047103a5c32e19669f4338307fd8daba20b4ce3173d52"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "367d809ad558e5640a40b252dfa46c433ae2d707f9c0b41aa14380f79be5d50b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa277b0a15860b79b6ec1bfa8c53c7f6a105f439ba503db3fde1baa7171f6fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1858480c187f0501697aff20fe6580e60c8468a1ebdccc4f2cff465ebe9f8d1f"
    sha256 cellar: :any,                 arm64_linux:       "f0ba363d1de8bcf24788ecdb23b1b2d1596c15dffa6d45fb534113ca0078485b"
    sha256 cellar: :any,                 x86_64_linux:      "0db1dc360c443032ad9d22c5275acf0288f7328dded7bccbb9b5cd848f4eda4f"
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