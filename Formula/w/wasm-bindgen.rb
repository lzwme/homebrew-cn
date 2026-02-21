class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://ghfast.top/https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.109.tar.gz"
  sha256 "30e5f80e8ed3db5c39b2821798fad215cb8f7ebd1de312a3b8747c7b713de12f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1c1aef6d5c639d03fe183ee88484436e0415443744488439ea8df92edef4237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fbd9fd7080e6dd9cf5c3275fa7e9324919ea8f6e6725f8324bbde8a511d2605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a499aa8d30bd57b9612a4c4177c86e59c0ca4b898f81079ea7cd7e5d774b6df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c25f6e34ad97f1a5455e511a57f03faa4cbe98edc9bc41104a9985ddf4f81df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9829ede81a0a1704b1a23dc8f965291e61cdf8dfcb3f61c4376b246e3b3eedbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc29c6a2af1fbb0813ec0ae9768002bfd2c0f7ad5b0ab6ec6facf7b3da9dc938"
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