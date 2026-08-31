class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "88181becf9b06603681d26a9f2e85b54003c6baf11c63c284b25e99eaaa40b30"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82130839f34e20c609d5a9af5e794f9f93d9bc6d0b1274195b8b107d6fcfce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd6aa7add43d86eb9dddba22c28dcf09134880b255abb1439fb8699c766dc96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c040a1aefbf1c3e3f42fd7d653f97e2463d95bc4e7f24ad2a6195f13b8ecb768"
    sha256 cellar: :any,                 arm64_linux:   "800c5c99206c761674715b237c858440c05717ea3b762395aebcebee2e62c68f"
    sha256 cellar: :any,                 x86_64_linux:  "8ce1bc93c9707b74c4e538affd06a3c88d8e05642b9c0aa6feb0d360ed879980"
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