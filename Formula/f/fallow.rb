class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.76.0.tar.gz"
  sha256 "188634d287b72aa0fb4315927ff7bcd2382bda12e9be2f2486470624407f5210"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f9e54c21f265333961a2a2b043bb5a8707c34a282b449bc6a054d746c8317fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a6e0c53bd81ef43af01227dcb827d74e0ce6c0c12b13dc9759f027accc74df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daca6058f9b5b31ae635b4080e19f461f04f1908f525247385822f54f7b7fcad"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba5e18d1f7eb820c3acf5ef5c45bd031096a70c623ae13bcc2045f5de3752d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d675fbd15ce812f0435a4ff8b994394de2337ae2a80cf4ff1bc15526192743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b1646112f0ac6549a0953c38403a2205c14eb2f7d21e4c58b1779b3f98b33b"
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