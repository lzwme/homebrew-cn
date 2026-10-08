class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.32.0.tar.gz"
  sha256 "71305ef34fba1a01e9720e091cbcfe99b00d28dcfb1c80ec5f5f365480012c20"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "499f5f3d341cb87353f904db82e7e903f1e89398086704e7d45e8be0e0f1065a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d46f2709fcf24b9fb48b81d792f0232728ce3d49e3cd48a6a21f83109aff27ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fc6e8da347848d2c990fc6037e964e3dec092924321a3d6076d4a4a463bcf14"
    sha256 cellar: :any,                 arm64_linux:       "b9f1fcb446f4ce80d67c6539216104b9549e7c64aafebb8caf334c3abe558c71"
    sha256 cellar: :any,                 x86_64_linux:      "21c20f772e6877238ad8c48c62347d4fcf01a07940ee2d5a0be18678698362da"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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