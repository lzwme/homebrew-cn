class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.34.0.tar.gz"
  sha256 "5cf4d84edcb53ebd5d83ac3650a47caf94d345f6275abe2215bd027870fd7403"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a79715b8949129012197623a9dc9041f034f2cf32fb8de3f3f7c018b7965d742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c803d19e5d7dbabb0b17096c0eadb5169f49e6ce52ebd39c9cc5e8242aec98f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb56a3aafbbe647cfc00a310706a2edee2c3200fcf8115d80d9f0679dd77939"
    sha256 cellar: :any,                 arm64_linux:       "44a8a8cef9ba65e5aa347905fccfcff5bdfc45ae7d22037f4fd84b6f3ff8f83d"
    sha256 cellar: :any,                 x86_64_linux:      "4104dfaadaf81647e1d4174a7a93b6465753061dc9ca5cda722399ff35ac0b48"
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