class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.126.tar.gz"
  sha256 "f6f1af7270e7a3f4e82dfd903f625dd4f1b278c601e7e6d470585e7e46e904cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78979b1bc44c1a7551e515210de1513543c83df50ed4912d6c5564ab8e776702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f9990cbf374e24cf0f9b3b0a93b5c6e358aa6940048eaf00c3048c187f8fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec73fffd5fadecdea815ee316ad0be0902aa0c64ca64ce7049de150ca270aaff"
    sha256 cellar: :any_skip_relocation, sonoma:        "75ddfa0e0ac90885956082f6463aea70c7d8d5a3aa9e7994d964443c0061ff01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f6c90e39c2bd3f88e0ce71231952b2ab6b365fb15049613a31b5a4de3a711e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492f479991cb691e2b6019373a6d647a57038f3a5639ce485c465160eece9168"
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