class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.53.2.tar.gz"
  sha256 "1566f8ff30ba93b2826edc01488723971b05dd2928391ced4a1413c4e84cddbe"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d263f49867bb80c45ae1487e7cf0bfd809a2bd4ef8c9f3a9fe14c34ed936805c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f6718a518739108f62b3a31e44397458b3ca79f11baabfd9bc891ebf41bdbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6407b2f0343d36f7e29fb2bba02393a44ea40b96a350cebe868d953eb765933"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb78a069bbbf51b37632a7ecc000c12dec8d40fe1d6f7dffd2c41341533d4697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c810f317087214d3b67bccb6754d9d04194d37d06d52e91194a2517f33275849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d78913400d2f01ec0eb8a0676a369449e91424fb8ec784a9db35d483d794c3"
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