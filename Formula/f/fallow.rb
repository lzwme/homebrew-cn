class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.86.0.tar.gz"
  sha256 "e781ae5929d510fcdec329a70bb9b25023fcb5301f5524c014ec4b207268ae96"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c7fe1c75f943225f0efc0871787ac4e88132d282403e24c907f2e3f90ad014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f056330a4089f1e4c493404cf3b61af6951e415334c43e206fac3cfea600c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9516a846d8fb28f0db324a57b5eca4805e40820b6f74c7511778b03c3e0cee92"
    sha256 cellar: :any_skip_relocation, sonoma:        "28e5640b6eae0e5e400d7ab483af95d1a9dff097c60c582414d56ca7d83d6a3e"
    sha256 cellar: :any,                 arm64_linux:   "25bd6bed59f8eaaea15467e83ff42bba9118cd56f3cbc12038ed19cb58f5a323"
    sha256 cellar: :any,                 x86_64_linux:  "9e0a2128f6d2c1a17d41c1d85f5ccf7bb1651f24464647fdf3f29e65c732ab6a"
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