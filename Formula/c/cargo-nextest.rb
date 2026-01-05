class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.118.tar.gz"
  sha256 "cd92b71399a14bc48223851139354ef4d28bb131986a172184d840e2c3505c96"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "278cbf9c3b50cf278124432d5ce98a80be23a5af35c9a83180b7ea71b537f03d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4981b6936ef383d18eb58fd6589e5c3bc073a1e4afeebad25beecc41b52679c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0102d5291d0b47fa3571c0b17a7b5b1c5c3b3caecc539ba0dd29d749a7cc991"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b6a64b77a0607c213cddfc881f2c718a69d3020958861a5cdabc92b05eef4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f7642492a0280ada2c1ad33eef2577b4228c498117010f00e02b434305196f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02cffa9006f0442b4681e2aabb944078cb50ac957da99cded8849933d3d2f0eb"
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