class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://ghfast.top/https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "e79d1daba3d9a6fc37193d67c9442bd8f90c228c27ead1f21fb6e51630917527"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee1836e82bb023d377db57dc9d21c179beba39082e46f0abafbfe990c315fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3547558fd4a318feec42de8b7a39ea9fa75b95c6412f9ec5d48971a45bfe10e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f7d6a08fc37bd514eb5d35954039fba284e67e15b9232ab4436596e4137795"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6a25176afcab86858046b11c8b8d50901cef1d3613c8573b1e94d32c9f5328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ca1603087a6db7314fda075f5955938e374ac0b4f6e3d6be66b9cf08bc2301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb706e68ee793f24ea68f47d9ad3a5c407abe28146cc44d5ab95612d52c8da88"
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