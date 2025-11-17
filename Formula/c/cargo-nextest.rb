class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.113.tar.gz"
  sha256 "5d7feb9c24494770df2bc218d0a791d6da54ef691278147ee149af57ae003f0e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed5f915f23d0d5c2cfdfa1a7ac5fe0a646c3d5a8f57c41fa7472b1c322304103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a761856200c3b931d1260e2783ba0e10866442a8da4d5af398e3628debe724e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a943f2826c325fb86f17dc6c1c2c050315dc03f1dd7c3d7175252a3ab37312"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ad238f6d923afb79a9bda1cb1f15a35ef2f0940932ca45ee171fa1764415f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c8154cd305b783e9a084504ed7593ce2625e45cc42c8166525a8da32d1baa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5280373d66ed4ee1f704016d6b24c0242751bd09aa259b5552e8133e54f45d"
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