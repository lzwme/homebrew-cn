class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/refs/tags/0.42.3.tar.gz"
  sha256 "1ad679659a56b02f334d2a05ccf9f07ca74140357932037c24fd4f64234e2671"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e2cffe830e61079b1b20280be079cd9cfbddee73a6a7165ddcdb0b2d3e92934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eea379705f0d224b776b3edc133b72a1e59f6370eed4bdd22679d14be581e81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c16f86aa6982b5846e0ba188dff0963d6f884fa89755fbef541fda40e7f1393"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff8b1b245963dbe87bc0ff838ce281763a923fab46a1f7a6134cb4f5195735af"
    sha256 cellar: :any_skip_relocation, ventura:        "1332f3525ba2d0d4c6e4b69a975444b4ec00c34da08a47c17c623d1e4a770aed"
    sha256 cellar: :any_skip_relocation, monterey:       "b4510d376ab42d81256bfba02205862faf77765bdd543093de9d115efd3589a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e490d2eb73273aedfbdffc3d08f57bdb3493ad9dcefacf2fd180c8f0cdc72945"
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