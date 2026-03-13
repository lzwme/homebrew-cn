class CargoCyclonedx < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects"
  homepage "https://cyclonedx.org/"
  url "https://ghfast.top/https://github.com/CycloneDX/cyclonedx-rust-cargo/archive/refs/tags/cargo-cyclonedx-0.5.8.tar.gz"
  sha256 "101e3592a378c2f8591f5836fb7b235393032bcda84442217c239b4ebd80dba9"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-rust-cargo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cargo-cyclonedx[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6873c5063435091be5114554b7d35ab766bc7ed874f82bc31a8141e309364d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846c71363a75d011baf2368c25afa26444f8c3f5a90a20e44431b23cf25ba502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adee4f88af3b63d0b60e3b557a1d7423740e301b4a99154555f729e51408f451"
    sha256 cellar: :any_skip_relocation, sonoma:        "a444dd8b4fd4a0a7c1f6ee8b0c0c654f64a77e23115216040cdb3a3f7d3a130b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca9dca958c65b3fcbf35c9dbf502a45c9ac6fb14166780c904de279c247bce1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e717e9d9b04e3fbff87862793e96d8abdde79541b8589187bd3d2127eaaf2e0a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-cyclonedx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    system "cargo", "cyclonedx", "--format", "json", "--override-filename", "brewtest-bom"
    assert_equal "CycloneDX", JSON.parse((testpath/"brewtest-bom.json").read)["bomFormat"]

    assert_match version.to_s, shell_output("cargo cyclonedx --version")
  end
end