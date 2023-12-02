class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/refs/tags/0.43.2.tar.gz"
  sha256 "ea74784c1def261e62ca2fcf0a66cf3ed53c64816367137aea4bc0ea957725db"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d684f9cb35649e8a1a53e4b24582964d774c13a716a7dd5dd2014cfb82704e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a52a2568b8a7fcd33e24e21ea94c3a6d44bea8b86cdae24fc0f656d8cb43a4c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d7da7c053047dc2f850e90a06e8baea5b00e5b8a3a933871f29c6961bab7deb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7b6d49966ce331e47455f19e194850922f3a4dff1f76a443658bb83f7bef6ba"
    sha256 cellar: :any_skip_relocation, ventura:        "c5f69e1fe680ac3786ad24ebcaec4acf6ec5cfaddf4a9ec8bb34a697d3dec375"
    sha256 cellar: :any_skip_relocation, monterey:       "88c2e93c988116f582b5d31d7bd544c9386ea8c138e12356e1cfdfe52b818d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cdc8d16e15698d55035fb442ec3ee557581cb8b065796923e7713e4d6bfeb6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end