class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.115.tar.gz"
  sha256 "b1a48bb44561f16b4a7f84bd3c2435b7d2016b8cbe4aec085a2c2bb9a7f54294"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab6b40354f6cd492891ea3a911de9e40259a2a1374c6a78794a8c74ee68884ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224e5edfabe18c2b93bd11f743201cc895b411e3c210cdfcab4570ab375cbc09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6e69b983d88c29d3cab3dca7c51cd6f86f9a8d7cd0057bc0db780a993f449d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c9799dd05fc31d5909d30a82f9e0921ab6822fe35d911b7d2e4bb7cdac64d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72cbb35bb634a0d4e043ffa28e1a02ad17050b2e0bc8b312f0b63e324e72cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32380108585217243cb19c917a48f8aac5fa1a2789e6eb9d3542077dc0f8c44b"
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