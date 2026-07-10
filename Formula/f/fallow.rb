class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "9153374a1c3a9b01f69dbfbb874dae21659f2c00d82761c48581f7c14f45ccc6"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a592b98d7912d65c686171140ca4eade4f66e794bc12075f88583db599af9a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2afd3a2706c4c13ee5029db21049a400eaf727be27b3e1a33ba42b06c61fdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419b428cd6a858c2dcb9add9216ea7e88c9890c3c907a61f77e8ff55faa8c3e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9ba769c6181c2b57770313f2bfd24052aaac8f2efd1480d9127e363ab9ac01"
    sha256 cellar: :any,                 arm64_linux:   "87b8c704d4355ecd659a93c79587e3b0c203146fb24934949ee439e9849abdcf"
    sha256 cellar: :any,                 x86_64_linux:  "f5702907eb2f3dc3d119e805bfa4614757ad2aca71ec7639fa177cd6fcc6485d"
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