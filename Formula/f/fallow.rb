class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "b18f53d05b3b2035afed7f4eabe35cb4eced3fd01b4297504745447f380c9e40"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c946430302dc5bf66303f9653d8660d611805a8e9483640bdd9f3eaa9b35fbf0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ac28a18def712ba7a4d9f15e5e7f0d9835a65fa4bc6337a7c11a99a32ceaf08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "411f5e7b375c5fb7670a532f76c6de1c9476e52e2b165a43a660ac099adc0e53"
    sha256 cellar: :any,                 arm64_linux:       "ec097efb903ee0b1a658094daaed13a3ea4a31c819f9d0a9929893985502ca92"
    sha256 cellar: :any,                 x86_64_linux:      "f0f74c630a53aa98454caf1cc033431d42ab4488543235986223ad2cc6ec6515"
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