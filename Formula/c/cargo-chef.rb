class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://ghfast.top/https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.75.tar.gz"
  sha256 "52f83c2dfd17626e0bb44b372d7627eef544ce22dd2b77333deb212159548ad3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62e91884f3f64b5eeaec0e99fb9715c696a334f8a1d2ebe430fbd662c03f7135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8a2612dff35394d64d1c2e1eaf212aa0e7f1f32574890ece147a3c207c5ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c290035620264b4925dded62080abad45f87aa8edaadde8e5c04e8e8952883fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "581bc92319e8a6746e96670a74135f1a5b9811a69531e23a6006f78b2ee91707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d210ab392a7dd203e8753434a8b3a7b977983f284583f7a6889a10db5a6daf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8bae37c94f9914e7901d4c718c872c1bbec9502e8569a376832ab52a1ea864"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    recipe_file = testpath/"recipe.json"
    system bin/"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}/cargo-chef --version")
  end
end