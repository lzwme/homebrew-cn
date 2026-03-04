class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://ghfast.top/https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "a1610b6ba4aa846289f3a86e98f0805a24c328811d682cb6e3f377274c3513bc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7355d2c71230cbe3e76627984d695f976ddd0a8ef84d23ffbf2a3b4f56fef562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32976d29bbbf27f70050a64bc0c0af9249f817f4ebc541c329a6dc5d26f7e0f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73388b0bbbd65acf796e8fa6125e8a6cf58c10d185571a81b79eccd50de88632"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f04720fcd9ee8627b4bd71d505e7b6f7bd9193ce707c6bfa06974e74dd7515d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2333b2d1e9381b2fbbb6e25093e2f96a953a47e53e9f23a1de5daf31fe567859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c4abc28de4eb0727e9b75673eebbdd6900a0bc45fb7a46460deabadf234c76"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditable/cargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        fn main() {
          println!("Hello BrewTestBot!");
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system "cargo", "auditable", "build", "--release"
      assert_path_exists crate/"target/release/demo-crate"
      output = shell_output("./target/release/demo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end