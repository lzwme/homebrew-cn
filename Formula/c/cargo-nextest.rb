class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.108.tar.gz"
  sha256 "d9aa0ae604e4a6ec4ea0249ae8271a557b05a2fc384aba139a23f7473dbc45af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f973b148c7982e61ee27cf98a947444c620c734e94c26501c05c732087a86c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1017529c1a89b25005b3763158619df1bb8437b988bfaeb40c2c6b18f9dae8ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dca9836ea469a60b4fbe203c6307ea209685d43798c9d8b36cb7551bfce7d504"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95d84441737364b08a73cd633ef8c10590a4080e901d7642e360d8044474fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "670199d39a07268a0bc735d1714bbf9b9cf1a08f26d82cf1d5a29f83f9f8521b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1d0dcdf09ab099b203876054191e42291f0765c9463297eeca43fdbdf19db8b"
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