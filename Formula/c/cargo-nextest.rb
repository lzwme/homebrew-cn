class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.124.tar.gz"
  sha256 "b8bb23ef33db369fedda1924f89aefb473099dd872899e5856d19c503c06e109"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d4d99f4cb0f93aabe6d416f5c6c2313c1a38a917130bfe9366d9128a0a434d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bccebc27cf789d8656a355526128a34bfe544e1f146ab35fafb43ed13a6d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bea9e44a176f72f5ddf47940fe1e7da3683158f4d03260a0f36379b24917094d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6afe2409f20c711db67547642433183e1c691973edf30aef3a77252bf16728a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98da2060aa30dbf021de9e3d1721a845b8109af07b12668c2ce74d28d5094e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cead59518bb03c7c8999c799cd5899eb63402ccb10a48530bf413c99cb3f432"
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