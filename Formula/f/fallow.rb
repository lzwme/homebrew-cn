class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.24.1.tar.gz"
  sha256 "f0c6afb4b0673d3725d8a34fa8ff202e8accf0376431c277d4c20f5bc2a539d9"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b238daec7580ca8c765c2a95a0dd9e219d84be1b2a46d203da8e4d4572a347e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4fd652b04c2e73745e48cc371eea5c33885278ca02b09e2a18e8479e9cd967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e87da087b8d5a49aea98189dfc9ccf11bed599fd22bbadc41b24e0b01b75de8"
    sha256 cellar: :any,                 arm64_linux:   "17216decedf938ea5a8bbe74b144d370cb74922958767bb6da3d2366be55e2dd"
    sha256 cellar: :any,                 x86_64_linux:  "acfa77ef13aaa08a0f5926af555fc72761269594c62ce6973ab2716fa8966679"
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