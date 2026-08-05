class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "65dce6b0485911d31af165399ada91d019f64c368dd9bafcc1da3e065d5f7b32"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b289cf13c5925d942dd0b7968df8094e399c1c9ef80ce4deefe0eaed01937cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775001d47a343bb1a9bedad6f9c23ab2ab86fd631da28e0291aff227e6b0829f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31fb8d1251964f551a2797be199a548b8295f8c122100110f8c3f974ad7b04c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "35825ce446b5c877aa742c57618201e6512695534501892d3df81d48fab0bef4"
    sha256 cellar: :any,                 arm64_linux:   "5a1050e43b33fdbf68bb5de0760f072f22377dd349f1ff2c3d251e05d8639c3a"
    sha256 cellar: :any,                 x86_64_linux:  "8defbf49903947d4877d705e32bef905e6f7cb212d6af4dd8cf81c1ee6af4755"
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