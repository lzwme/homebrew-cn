class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.100.tar.gz"
  sha256 "757a05ec0a5b8d24130d0bad84bc3bbd621a4343fc1c0e59b7d904a8c80d9fe7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a9f057402efcd6036aef30b21dea72ac3ad1a16a01ef679b2ab688e3187262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69ee2be83bac0ce9153a0cc6e1c86146e25df030f6b8605e3d88af726779ee2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6db72478fde9a9598769f94fe7fbc3a8f8e77ba683f12ea536e7b9afd9ff8b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "eedd4f39ace5a54f0d94c2e71617247b757cebe0b4b8bf9991d37687f18cb7a8"
    sha256 cellar: :any_skip_relocation, ventura:       "0d2a6c763111e43b689e5028703eea062c97452b021d04afb7ec6614c5021e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d040cae2cdab577e9b40af61a34cd551d1b59dffa579fd7223e6b9698b83c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b013ab4476188fb3ff1a8cec0ab37b234fe91e9b6e1e91925470340544d5e964"
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