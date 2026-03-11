class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.130.tar.gz"
  sha256 "1510769769310eca7b888317cf33fbe24c0203a8655f4b5802438f1e279788bf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1046e2d7465d26d3c8851a652c945360e4631a30d4d5120ff835d75be302fadc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee6dea8cdacac1c6ca6608c818b51203bda445cfe318858a3f24b8c50a22c17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a6bcfb66a75997bf634bde6dd3a2f64a0cf12a5813a4da152ce80e432aadaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "42785f56bebed34715da2ffcf7186b741c29afd8a2811c0c35d309d22c479805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74ce6a4b9c7491bb6a366fb74ff4b446bfe9ad7caf6258a4d7b51612dd72a4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d692917d001d8452ab5102cea10a2ac484aee7457f448a3d825f1efef24a450d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
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
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end