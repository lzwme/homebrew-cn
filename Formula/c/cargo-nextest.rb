class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.121.tar.gz"
  sha256 "1de916f20a6d7eabc8b5027d7723e8b32322f22185784122d49e88cbb0892b38"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01cf041c0e93e4d022e602ded8d92fe2a3b193b466cf6b5c9a2c482f81e7666d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bac2f62ffbf4a06c2a15ae57d0fe9b7728fc748ec29c3bbd7c0562bdfcc4e39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709947bbc328ed07af0ba5573bf31c3d99968231c8f06584a1fe4789ac673e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "36cee122cbe946ba3b8ae835feb1de93456affb58632a483aba380ff0530a869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed0d9a942b2fb47dc3906243e9659822eb4b9440804529ac32530384c5ae846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94ca663e38d58de4e5fb780e4a6eef61ab407e4748e060778c728e90665af7e"
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