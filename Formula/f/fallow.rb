class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.35.0.tar.gz"
  sha256 "480ade396aefbf1bc732e2ebf50e54e84701cddb073ef2f64a55e1ac8d23400f"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d80e124a736333e317cb98087a363beda6dded2e7da595978d1d1efc41039f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c15a86564a54f8d95b8ff67c82c125ca301eb3654ad47c2e1a6575ac200d5843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b99e6ee510ad572d20a38c89d7e6e168705cd2ffd063bdccba57646608fbfd44"
    sha256 cellar: :any,                 arm64_linux:       "1376f5ccb4a5a7fc6d44ac4cff5d6834cd6f5eda0aa6ffea5cdccd1aef5b2a55"
    sha256 cellar: :any,                 x86_64_linux:      "e1e5b9b49dc806bafc01929b34eeeac17d5bdfdb6a25e0e952824bc1b7f926b5"
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