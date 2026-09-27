class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "3289cc75e545b9f9dfec31bcb8cbfe75605384416f839f2e6493551a6f335105"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a0cbd5656e72bf6bce00f77bbf7704f82bcc150ac6782fe3ff8bcae237cc8ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9912cd7ec29821fe06c225d9de5ee1aecb269373fd973b1cdf1dfdb565f3dd35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fe099e75eb6800e9e434ef646746c7d00d5e85f2c5f240acc2e0a9191a6718b"
    sha256 cellar: :any,                 arm64_linux:       "c6509f83686a14dc9c1160cbc53fb84079cc3a25952c407f7284877125e87270"
    sha256 cellar: :any,                 x86_64_linux:      "c604e5dde4d11c90132f07c70ddb6f1b3a19bd989bffbe8ddd692989f0bd4192"
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