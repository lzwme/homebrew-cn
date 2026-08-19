class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.56.0.tar.gz"
  sha256 "cbbe05e476fe862d33d9f9b0e56eb7c8fb3866f8508dfe94f75f914c8df9c03b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ddba42bed42f6e5d947bac5149a5b3ce610768895120f7681d0e62f70e42ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef754cc317cd0ef41c2410596d7a8e21b1a34d026cb4a881a56fbe3c69b4836a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df0f491607197ae6f92d701a7ca7552f6337760c16c701a81e2f891732bd62f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f1c8713e9cbd28904fed9ff1717a6be277c703b809074ad878eb18af80f212"
    sha256 cellar: :any,                 arm64_linux:   "b2692a1ab46907ce64b1ded56cc6536491930555d1adfba1c56ab0c3d42fecab"
    sha256 cellar: :any,                 x86_64_linux:  "ffb73e45a3dd11e3a491093c43f2a2d3fa7b00ae0bbcc39517dd95c31ec4a00a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end