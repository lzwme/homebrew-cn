class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.82.0.tar.gz"
  sha256 "b7fb32209837e7bb4cc9af3e29db54f63d683db6217ee1e540c5d8fb30b30a0d"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0848a092526ad6abe39b1b79363565768ed6fa969dfcb8ab871ca9851a9aa50c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d399d7a366d91c324cfd16d4a84e714a48ead1d27aa44e4a771ae06a18ede43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a829453a486f4edd9b45e1a79e7672aca7ccb6497e14dd9947c840b5ede93413"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a3a05147898cbe3b0c9dfc66a172d01405e0c6555d9e795216086a07607da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3bbccea4a879453504dfdecddcc724010e6145546ffc84ed96ee55bb44eb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01bc4fcc098a53666c9a60c24b32a59f802487659d2e147fe840ff747c4981c"
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