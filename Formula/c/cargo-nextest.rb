class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.144.tar.gz"
  sha256 "ca0bbe5138a588e8ee57da135e952d865e074b91bcef56f28a8f26eefe63bde2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "223ac1dca9f0a2a12e97456d4a5fb4387538a6f0cd01741d167d67c3a5bef0b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e556806d99b85c374ba5a6e53295ecedb24425b78657a25a070ee7677ceb4f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050b1d4923b12f0849ef77e0688e7a703454e8264f686bd32930457dbcf4f042"
    sha256 cellar: :any,                 arm64_linux:   "72d5adcb29f68b1ab1daafd60fc0bd7f320a22b8c7fe03f99b63187841475a60"
    sha256 cellar: :any,                 x86_64_linux:  "106e56ab12bba4f19df23e45a333830c2c790bc96649f3e9e5401d52a929e314"
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