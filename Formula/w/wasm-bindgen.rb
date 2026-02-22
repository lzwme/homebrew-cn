class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://ghfast.top/https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.111.tar.gz"
  sha256 "18bce25410a3a0fb6af9b5e83b7041004e91f6faecdca7ec098081a612f21487"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76a22acbbf500b1a226d8bb2d183173b8d19a6da9971fd338019e6084ef242b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f8fdc38d1af93b3b8a5ceb4311d637d4b88000a749293e933065fd9af31554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d1eafebdb6ca32e3a76efe8597021358c9799e9147ed3f18e4abd8ba73c01e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d42edfce1a5a8b42078a5a640155f5ceb47d310872c32bb37518ab422caa7018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a4c2e324429ba57e68da2ddcf86922e219720fef49fa3a062083ed8957ce29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24372043510e15eddb3f6f3fe11a180077561f8957dc0a57cea51755fc94a87"
  end

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wasm-bindgen --version")

    (testpath/"src/lib.rs").write <<~RUST
      use wasm_bindgen::prelude::*;

      #[wasm_bindgen]
      extern "C" {
          fn alert(s: &str);
      }

      #[wasm_bindgen]
      pub fn greet(name: &str) {
          alert(&format!("Hello, {name}!"));
      }
    RUST
    (testpath/"Cargo.toml").write <<~TOML
      [package]
      authors = ["The wasm-bindgen Developers"]
      edition = "2021"
      name = "hello_world"
      publish = false
      version = "0.0.0"

      [lib]
      crate-type = ["cdylib"]

      [dependencies]
      wasm-bindgen = "#{version}"
    TOML
    (testpath/"package.json").write <<~JSON
      {
        "name": "hello_world",
        "version": "0.0.0",
        "type": "module"
      }
    JSON
    (testpath/"index.js").write <<~JS
      globalThis.alert = console.log;
      import { greet } from './pkg/hello_world.js';

      greet('World');
    JS

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"
    system "cargo", "build", "--target", "wasm32-unknown-unknown", "--manifest-path", "Cargo.toml"
    system bin/"wasm-bindgen", "target/wasm32-unknown-unknown/debug/hello_world.wasm",
                              "--out-dir", "pkg", "--reference-types"

    output = shell_output("node index.js")
    assert_match "Hello, World!", output.strip
  end
end