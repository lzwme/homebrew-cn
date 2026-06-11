class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.92.1.tar.gz"
  sha256 "2404bb1165509d667f5e200612851d8ed31547690e6b5b0d30f51b3d14d6b771"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f103cea2e0f397b4381acead8dbee4bd17a7fb9463c99758a6b3f4514613f4d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f9864c8e11a67710b4a28c1f9722857e14a401ae1c63826bfc786b6e94f320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff38e740c469d4e9d7728111951d273f0c549646db1b7a210b42b5369368c4c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6c2c16cddad875e3b74490fc434fa58f80dedea8d26ea54c9728f80349edd4"
    sha256 cellar: :any,                 arm64_linux:   "76467e49027b4e6d7f9f6fbc054ed3eb65197a4f1e487365f0cf575e6b1efb29"
    sha256 cellar: :any,                 x86_64_linux:  "85ccc4d1b394d2c5d6e764032cf9b7fddd21fa951f62481057cb32488bb2a878"
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