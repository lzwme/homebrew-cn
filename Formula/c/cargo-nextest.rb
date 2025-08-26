class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.103.tar.gz"
  sha256 "b9fba05b7b75cc5d0c7a423cb24b2bb7d827856f4cc4fe43206ea5c5c9885691"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1d314fd289f804926fbb48053a5d12642e5790d9a2008027d3f1daed202c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7384c4636ad6be2211d143ac84f8b408e913c24bab5932e1c45aea4a1368310d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7676bd6df42d50d35bdd8b0ba88acbdc05fe8eaaa158755d69d924ba78c8d51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1ae20d812769bac56e12020f8737542f38dea20463dba356a970746c1ecd4b"
    sha256 cellar: :any_skip_relocation, ventura:       "db0298377652adfebf8c5a0fe005b4cb025793420df4a053b13801bb6c1cd864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1f241a40ddaf723e7ae8c36a1446663911cd54e4c6c8e28b732150519066ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb03a7600a087fae4319e00c7a0f92c0670f948ca3227d68ccc4e4b51ec8727"
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