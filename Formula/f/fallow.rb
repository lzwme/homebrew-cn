class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "97439d40cb689ddf51237681c5475bfeaab9b4477b28a160280d13b7707b19bb"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033b3106d250e83d0b54030be73a56ba90e07e1bec5fe405e7f6077b931ac0fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1fd5c17fbaf0007942aae0359217d15de632b51125b765486bd3edaf1ad17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d038fbf079599bc604885b427dd5629467a6eb1f4e7c964df19931ca7cc5fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c835b34bc0ba85b0f219f0f7656372d6b94428deadfe2c0d8c0c4549885b02f9"
    sha256 cellar: :any,                 arm64_linux:   "1167a146dc690318069c6684ba8498f0becb5fa3aa77e4ceebe6e10d64094c82"
    sha256 cellar: :any,                 x86_64_linux:  "dcac4523fd8e7a17e887e30ccbdb8c2672f711ec8744d85c4113037ea3b67400"
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