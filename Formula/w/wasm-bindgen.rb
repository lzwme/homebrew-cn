class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://ghfast.top/https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.120.tar.gz"
  sha256 "59a416c9b4f47bac5c1a72e5461bf09bcfadbf8fcefd31968c6349713bbd12f8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881a7328b6fcd545fabc81a63313f0db7261d3bf0db4f7bad73133136dabe128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc0ef541a64636ba28407ba0cec4ca2d04bc6d2d3372f2389bde53b76e369a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f0dc0c49ec03483c2c3e7e88baf795a14badf9167375afe72340795594d1f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5cf78aa37556b96fb60f5f44a86eab88308d2e76d3987ad9d739edf891923f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e030123b9573ce48d1e57fd391f48d321690630f2b1fd3d7807604547b2dd809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171ef87015602866d7097f835719e4b2bfd81fe62a7e43c6003f7a4b0bee6d89"
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