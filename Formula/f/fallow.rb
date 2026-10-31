class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.38.0.tar.gz"
  sha256 "3d8ab5c42a0ecc6b47fd92b4ca8a9752e506c1bedfa87c4a97896edbecaa592c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c42e1d91b69e29805e4008aa4c150b8f16a0a8c050dab6a462f4c01a03719ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46632aace87c429bd7bf24e5f0670ebedc53ab0444fe260c0d05b4ae48887f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23cb933251076afec7bf74a8f01a8d4604509508e51cf175a8df4d9ecbf70656"
    sha256 cellar: :any,                 arm64_linux:       "c1cc23e7ad861f733d320494608bfecb82fdc98b15fe034446211906ae1d142e"
    sha256 cellar: :any,                 x86_64_linux:      "e65b948641d2dbd797bf0d949cbe7e78612528519d9302a54ce974f76fb3456d"
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