class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.33.0.tar.gz"
  sha256 "669c815bf19157e7d02d05a23e1a8a4b3084e317139489be80066d9565a65aac"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "461af9cdc020c3126ffb6693b724aeb0b16ada0e932717e37c0224ee99849a00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4a30b653c28cbe6e677b4a307c3d00d7d695a5c654a0b671b6cb0a82e025c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70979d92b2479d6a10c689649b6f404b20cc07acc3497b3b6b1f5cd12ded7698"
    sha256 cellar: :any,                 arm64_linux:       "4d7bc90bf7d391646294b2ae5b178d11fab75854b873ecd8ef9c8f9618f2fda1"
    sha256 cellar: :any,                 x86_64_linux:      "b1c80ef1a57ddb5b9082e9f537e54485588ceaec0db98d9b37aaac714dea755b"
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