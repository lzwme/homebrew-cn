class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "351745f6b44848fce1799dfc2e7d9937867f8936cfbd5bfb73c8496bcb5e133a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c3dabe580758f529f10fb6716b884763846e954c78b434f4b81b931b7dcdf9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288e49a077c3c75d2441972d77e7cf9c531e96cb3a090ecc72ed07aad4af4bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6869078bdeb8df5e63920b879ffc2c71872c7ac8f73ecea9060755af285a4a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d3a857121765f4ee03fd0436ace039d665a75a4c71be2b172b670362d6374a"
    sha256 cellar: :any,                 arm64_linux:   "b217b6044570ce31ed241431b84c2005bc15444bcb4cc25592f8d37e67f23d67"
    sha256 cellar: :any,                 x86_64_linux:  "451cd2e485180b63e08f4dfb914c9301c48da7b9a79fec13c81ebaa95080eeae"
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