class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.148.tar.gz"
  sha256 "c047e6d430ab7faa807736ccd10245ed60c14c497584c23d5696c156caee43f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cdadc14037fc9ebfeafe1a6e3f3ca81d9fedbec943a06c80239e68df1aeb35a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "940d1a7b294a528bf97b6b7014b0b0dffc51f66fa1dff401eeeda87c8ff0765a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31882a088a2e6b184ceb87075d09343960261b9aba4104d9a4c6dae76be35afe"
    sha256 cellar: :any,                 arm64_linux:       "b99e55bed571f2e5d44a5f53c7518906734bd0807bde203f7e6b5aeaa617de78"
    sha256 cellar: :any,                 x86_64_linux:      "05c966b812a1dd798b59ecbf580bda393fa9bf5f8530149785377c2a82ab3d4a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # Test downloads a beta Rust toolchain via rustup
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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