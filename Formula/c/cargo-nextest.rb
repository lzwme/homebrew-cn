class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.102.tar.gz"
  sha256 "9b9a28ead2ab8df0d847b91c7b35bca4cfb47b6755b48cdfaf37412a8f033426"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e48d3c1d5eeed70533c2a2eb9640a29a18f8f4a4ecd9df141642d02936476f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bf87bb616b806c70d223eeacf90175b6bbab5346a26884d9787dca212f375d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f35cc6a90f384c774959e0b97631311e508496efa025faa36c9a228d42abcb91"
    sha256 cellar: :any_skip_relocation, sonoma:        "685ef88112ac150a9c9c30fef71d169198ffc554609816cb34a67b4e8e12b423"
    sha256 cellar: :any_skip_relocation, ventura:       "ef95e425a7853daa7f5335d7e7977589b5f19b65609735649b5b9c866147039a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b453be3a6ab1ad7d46070ecb02395e02c2fbb9391c38be93e19c232db5c73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917f014dc4120df834033679e8774704d75b34bf4f0cac007d87ab2ef9036eb2"
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