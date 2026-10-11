class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.62.0.tar.gz"
  sha256 "0f0fcf1afff40f098dce20743730d69e1a192d69a927cf3cebdcf71ea7f26e5f"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32b83e2d2801843bf8edeb074b336014d021c19006c93b4ce5e5850cf840ff3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7082c944fc18e7610a453ec463170f57b3275cbc9fe7b27966745bd13a7d7e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2fb98a981a8117580a5d30c7a077dc2c524a22f38d2ec1adaf74f5cae8dd28c"
    sha256 cellar: :any,                 arm64_linux:       "6a61ba98be9af750c698235942711447f8ca7bb4e929c8036bac102feb0226c1"
    sha256 cellar: :any,                 x86_64_linux:      "552b8bb47facc662ade1583df0fb7033fe8ff4c66c622ec00d94475365f6b738"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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