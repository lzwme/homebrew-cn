class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.120.tar.gz"
  sha256 "1bebfe429e2fc77ae49dcaee6ab833056b4d69646b25a3704534035b88d48b86"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e769a0b10d5009be8adb394684aa014c4462a57b7aaa2c160e609215e7dabad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c54612d0d589551ebfaad457e2fe0c91c3cfd91f7ebe1c44afc564ec2496a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "494f6c079cda2b66e7f4525531a0a1e09995e5e4a00283edcbcc17bac1b53c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62b80a7d714cdcd2f359f63dfdaeb173c61465a81ffbd37c331f9473d22a569"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f009abafd7cd877481ceb5faa1b3e85a5612cc2468a99c09f3e90c50b0a6e4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b09ebac46c8139c38e7644bb279931bbc8113f5ac06928605c7f9c2c8ff038"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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