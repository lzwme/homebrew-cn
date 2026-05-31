class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.85.0.tar.gz"
  sha256 "4dd672728c1b031c39aa2105e2ffb085ba4a1aef4911a503c1239795e9c6a63f"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68efba4ea1cf44ce92b9c2165f6d8aa1b926515ef00b292aaff4c2a3e12d524b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9864ff525f801f9a69baa4ef741a514b54da91a9f734c4e20d55cfd7c674efcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847c811558d2213da6ca35008649cc8e42531a67930b9d645b4649f267b20cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4931745dd97ee0a7f3d18806cb43533f14c75b4c4004ca71bce81b3f821b70d6"
    sha256 cellar: :any,                 arm64_linux:   "3510cfcc7cb0ad9a02d0a7eadbe8f887b0da5a2cef9bd301c266d53defb63d75"
    sha256 cellar: :any,                 x86_64_linux:  "31dd670ebce5002d9f3d6fc3cd7bfc47631a6d39c1131935298279ece1a0496e"
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