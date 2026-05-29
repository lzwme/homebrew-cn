class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.84.0.tar.gz"
  sha256 "0a8354d3ca1b5ad13148652fb156b8ab3126d63349d4f5090409b4efabcf45db"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e6ab7ca4543c9b58b6db4c25688ebc02ddae4fc83fd332a7a81a2c528cb6a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90547052b6c6fa8a5468b77b3d6a0f5298c5ee8aa65c97ef20b67b01eef223ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "704dc95a8e6db4085211eea25ff2a2c3c4718c7a1ac37f192216136be3d01448"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a348c44557a462e842990fb2e3c808c23df93c4a199c7b246d1c4fb5c4f4104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ca5b923310728474854c96cbe7a03892eafce9b677e6bb08354c28c1468182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c62e123c4a8ca4f0f8fcacf16872de61a1af5553f14abd3f8a2abf32a6297e0"
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