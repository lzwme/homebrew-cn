class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.39.0.tar.gz"
  sha256 "7b569bf2e12c704d7a4027ebf3bf8f3c5611eaf69495955d05a2f0c3a704f8a7"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7659fe3af441a4620b925f03737723117c6fb010d7e4dd6b3f54bb8268a6533"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef603223f3598b9f2fa7d04905685034c27363e740fe43df848a5115dadb73a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec16bc446b00345c4b33eae5aba2851d18fd6f0682518d92878eeb6f3165e053"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb63f2721cb5715bfa03ab5aa65cb2ae5cfe44234488e49aa670acd41c078f5"
    sha256 cellar: :any_skip_relocation, monterey:       "cfaf2d23f38c66107a5836026e6b10819bbe6b0e01bec7680022f851f1910ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc8c5c2299ad9b90c4563a6453bb0b7bbd652a2da9d4c8bc6e630dd2ae0e09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9995870a3f3b7709452270e0a683174eaef7ef6c4b6fc00878c05bf0b5fdfc"
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