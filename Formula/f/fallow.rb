class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.77.0.tar.gz"
  sha256 "9ba127dee6b2746f04dd705cb2f586bc9287ca4d0e301145184b007e9618d2e1"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6626bb73038d6172e686575706e79311dc783f061eeb8ce880e642daa4060dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712de3fd11f36185b717b15a632d443e39ebdb0549cc11670c07807282312fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b2692baf6a665336262785a9b642f3219a012be40d9c80140b3988a5c66860"
    sha256 cellar: :any_skip_relocation, sonoma:        "3340ac747ffb5237f35cf7b8220cb15fc2ba62a0ccc154baf6f1cc8c499b8645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660a44f6c36db355b3ca354354f28dcc6b93455ae1b6397aa18813affd6ed510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854d025fb3ab7e91fec3246af4aca51133179b74ef7f10cd207176d8b687fbf7"
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