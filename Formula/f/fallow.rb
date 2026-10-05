class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.31.0.tar.gz"
  sha256 "e0eed1c4fca276be30ebf830ac1faef75b2f676d5bb8a8e1ced46a35c8287835"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a1a35138a70d49d348ee5873fbb215d26fea18ff50bb7d092bc9fa38027f29e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "102623c9187360ec97a57385187853abf087081ce260bc4cc6651cbe9ca21e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5eb886dca23afcbebaef88edac488b5f6b8469574bd3ca7e8aac05b7f13cd99e"
    sha256 cellar: :any,                 arm64_linux:       "7f4950aab0ce2d88d6f562a8605817d4c95ee7c4e5105d6c2a59c3afbdf02d67"
    sha256 cellar: :any,                 x86_64_linux:      "9cc22761ca67461fb8c39a676d9bc04973176a5aad48cf3d25fa9c61df540217"
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