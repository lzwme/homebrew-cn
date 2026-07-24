class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "e149b9060d526f4b79104be9a7adb13e7e06b01219dd16efa27a1bd1fbc39d6d"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c91679029960e2eb84b31d3cad10fb46ad70de3cc499e8b23b50a6fda06952de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef763eb4ea42bbc23e64a4c924a58b5f958a52452a539011eb3924d113eece2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b04bf06cceb1988ec42c68dfde3cdcf86bd8dff83e5d4904e89ae8d3fa2879d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e62feb189edab992955fa33251db83f33d284e8fb8b01c7fd17296151898be3"
    sha256 cellar: :any,                 arm64_linux:   "04068e0572f0abc23044616cb7723570f0dcdd0fbd050f557a391d021f536c31"
    sha256 cellar: :any,                 x86_64_linux:  "9a2609c1a8e5a67cf3771d8e7b73842c9784121bb1214aaf8071db7c5fe43643"
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