class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.106.tar.gz"
  sha256 "b1dd5f1a1734a71d06358a23a6f7c867c12d8ac432feda7519b91cd46668862b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a9f78ea22525917518422bfa3c8e231bb3bb323e2b8346fce19731a2620d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2443139aab57f7d8261484efc575af011f20382d132406d0789daf8187e48602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2c0db2ec2eddd908c05bedb01630d801462a3cb6dc8c5d49b6a73e091fc790"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5ec4ece1273765e0c3f9d86d8479e4054b7604b91e937cd134d34e727bc69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a25cac39dcce128cfe2c6b87827514ed7e918be107cceaec0a32a8f13a683360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceeb81447b7381d0c26e40bc32a529b24d727259e3b0a1dd830ebcd1f9eff43d"
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