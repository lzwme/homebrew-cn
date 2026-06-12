class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.94.0.tar.gz"
  sha256 "11d247f6e32c5d68149a2413cb530d3b8f7aa4d1af4f2ff495fa9ec53d542066"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb0ac6bc98d122f9805fb62502cbb64b34124c6d39670f5ca7211eda94861b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbb683497296dca23b8fd11bcdd5b4b1b0663a812a898878590bcec4bc1ecae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e74a7bf321058c538eb7a52b655ae77d528df593a5e554014f1a9f0f7e78e6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "01585b58cc47dd85129bde096bcad6a908456e95e9b9f7a38c10e0aba22f5646"
    sha256 cellar: :any,                 arm64_linux:   "0185c69557ec217d546c13a639de3df08eb8f4d43ba2be02d97cbd45cff3214f"
    sha256 cellar: :any,                 x86_64_linux:  "41ce37fcdcd529e941cc53d1673118c298532459a49bb4f4af69854cc045e59a"
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