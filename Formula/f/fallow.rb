class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.79.0.tar.gz"
  sha256 "91278b1ec69573068f05b5d249608296e7cf9e2aa74376219eff1e7bc9e215a3"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d30446d7e6ac841ab8f2c917c98ee429d668a0b57a8eecc1fee351bfb8a50ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154bf01ded9b3f8e0e9b89a79c9bd6a7eac6cbb6dddbc8ecdc75487974a834c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3de9a8cfe7cea879a257c666e13f77bcc3e9faf12bf5ea26d86ef9067886657"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f48793f45021fff4f0a091c47a8c81e9c24a5dc2952edba71efa6cdd2bf24c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f346859a5e7c78ac8123ad2754bcf29dd292fb675a6f44abd4e895ecfdf4be63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577bc4b3a1a029fd9b5319536cea2986600ceb566d213b7b469215e3aaf7a2b6"
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