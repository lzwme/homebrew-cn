class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "29aa763db12a6a4d6013b21ec54bebd8d91a237ef6688d467a5b95823d01e0a0"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d2ce1e1e3a293eba8cdd2881a3aae87721bc8bc13174cb6389f01e3a712c7f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975d441e9d78be69cba6b4655e43caa3dfe276f01578da3ce3d2248d7df11070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "286faa748d59131032a93d22040c3670d8dee764c818df15787f41de7b2071f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "477c47400c98ce7bda19fbc8d69303068560bfd8c1ca7576e268ab6bcce8c3cd"
    sha256 cellar: :any,                 arm64_linux:   "83760080de49e75b8d6a874951db4d9affb65a95dd84abe4e345940b769a1051"
    sha256 cellar: :any,                 x86_64_linux:  "cf0532e215bb53c3c7b23a797e17c959fb71a14b09a0d188ffc6c1620ee95c0f"
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