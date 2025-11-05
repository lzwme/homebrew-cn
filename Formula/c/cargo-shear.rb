class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b53adc104d32e59bf69b910956ae933cd9891ee6148741cd5231199f0e3b1fda"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c82f9708a2e86aadb6b4caa27d5da30b3aafeb0d9756b2864639062bc92c96c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140dc1a6d8c6ada6b1ae30a8b678c20152a43105a6388dfc13e2d250eef35abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580917d0b28f0361f1fe1cc66de8641a9070617b66d0e6ee3517e27e2341dedd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4b606ce7ee6c59a923d3f237cfa3b09ca28802deed59e14d6e058fcc40ccbf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2b52375f72aab3ef4951b7adf8bfe18477ae6a054e708a40694d104dcbb4d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2fc4fb89ea7e15af3d2d5a9c2edfb8aba5b8502d7f1b55394822701ee9f708"
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