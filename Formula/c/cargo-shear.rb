class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "db27000869b63741e4f37269b1012dbc813c2ff0faf3f9415e9fa771dbb2c88c"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "809a5dc5dbee9df9ae3d6d7306c47d4468a84af2a0fbfa2468bbff3060bd3ad6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de6b74d906607b85eb3075ecc9d89b237dbdb2ad696a2440dc8f6e88341b05d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4226228845520b779d10441731ecdac0740ce61c0d9f2defbaf6d385419bde6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3abe0d9d43962ee4828d0e92043872bd243bc91f4cc3210cdd229e53d8695625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac5bb442a11ff85ec47e118e0d3b37838e8bdc59e0ff9a3866d35622d4fd6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650b22f8330577a21f6126f70b42ad1e13b2c71ab5c2c606e1df89badcec2a29"
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end