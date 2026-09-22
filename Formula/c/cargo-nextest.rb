class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.146.tar.gz"
  sha256 "c82aa0dfea628ff44b1f3ded405aa53ae74615c268bc5f760d32238e1b88f6bd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e07139a60f8c86a175eff1c14593ead2c06bd03c79f5fed30a4bb8f52d95e4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ee3c779578ae330f37be925cfd53256afc3e35d39b00bc02f13ac3a03ec19de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0500536ad9a50279623fd4be70a311c59c48b1382b886eb45fc495bd36a7a463"
    sha256 cellar: :any,                 arm64_linux:       "e79a8b229aeffda9f485d6a53a2ffa876c2a0987e2e2bac6ade7296f088d1644"
    sha256 cellar: :any,                 x86_64_linux:      "8ff2db243adca71982814c8fcc45f7ba69e2abd81255ae8125fc721eec8db8cb"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # Test downloads a beta Rust toolchain via rustup
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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