class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "5a368a903f96e6e142ccb2f8c63d8b1d8291537cc187ebbe9791b7501eff7c34"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c151133ed973e4db54c9638ba81fca8f91fa3ae6be75468589655373c05b1e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c048108846be93a12e255681097bc2563c5f8138190d5c21468a07bba9e2497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65ec94dbe4dd630cfe352452c78bd8fe38d93bd3a427cc3f3982e8b2bb9a2a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6d4d4ba92985b6a1e7a43f9ec18c4290260f1a14fefa56f3575282b458dda1b"
    sha256 cellar: :any_skip_relocation, ventura:       "5fe3ffd7e0ee584ae32dbde8752854e5fe1102416911f5297da9d0629fb00a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c684b24c9fd30e814af3080c0a1d0dd2e5e5b23877d9ee7a24548dd2d409a7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2255ccfd83c20e28b515a3b34ec89350859628c80eaeacf135f2c6058c2c75"
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

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end