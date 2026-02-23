class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.129.tar.gz"
  sha256 "4ea6afeebe539c935a3a8c5d248b16d6024aab834cc9ba45cf9c250bae524171"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e5d320b111d5cefbaa4c386a95ec27c6929640f065fbf9d7bf47fc6caa9414d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d9b26050946165cca25653cba25233dc5ab7ba2d4f813b18404547d0379579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f77dcf248207b4bc0e63e23510c386c8ba24cab2d2833ac8f76647cd298002d"
    sha256 cellar: :any_skip_relocation, sonoma:        "19fb2f164f8b285abbb6b56e8039584f1a59cb7f66c781a1e069ca4db10836ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96cd858991c09be9503b9424fbbfe43b8450a3023d65fdd75a92bf9ad052171f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7a4fc1a52a3ae2d991befb98d2242a284d95e47e9090f03df882d252dc1e0d"
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