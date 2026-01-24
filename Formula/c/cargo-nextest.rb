class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.123.tar.gz"
  sha256 "281228b1ed977c088a5a9f5b5448cac6cd9c23c8b35602f671ad50baf8875c10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd985debe940a51ed6833289d43060a98a25c774c3bd5b49600ea2ab9a20850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717878669b900b87f02bc543bca3ed005a67892a8eb8c8da41058a081554519b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a1c76fe2fe2fa7c2f3e128bc9ae5cb8ad853c2d3850914c46e43b4f61fad6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d409280bda8421c8bdf8ced6b29c1de87fb1fa710ce6a6d072c094ef11b09cf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "689728ca09d371d6a1c6933bf6aeba4df3c36e5aa8f5860c7839f9d9fae31949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94473885ccb16b9e5d140299cde9463e2dc39602e3cf3887f74e45a229f3c6dc"
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