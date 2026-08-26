class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "ce95fe271ee0a6a175af8827f0abccfd861aad01e527b6cc28e84fa8ae74f091"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d8a8fdc5084d86d35c6e478679746a02e18872e1ca3645a216e0b825e7106c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75d90a75cf9e73c835a9ea98478553950cab83fc701cf6aca3af56c0571fd5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930c4c09cb57192629df2483fdcacc553ea09b874e8f6ef5d040c0005ba86697"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3776c340e33aaa4a734f5f838bf7da35ef8ec728c11f3d7c4bcb5416df98be1"
    sha256 cellar: :any,                 arm64_linux:   "090c81d5fe1ab6b42a4740ae11c264cc513809d7b30947d6f6db18d667586b57"
    sha256 cellar: :any,                 x86_64_linux:  "6b5ff0107c7b2c546448fb41e403f27a9e988c90acd657a768a70ead3fdb830f"
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