class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.82.tar.gz"
  sha256 "2aa5daa0c60f9f80e75dd7a2c775fd95833907bf2ef0592f628b9cea958fd785"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291047698d9117320c6239d6d96819119f719bee43d7d2cc4d0acb09a5318b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137c565b290168b7426b6ae23bf862072e0ed7c331f7cc76603c9a829618009e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7c13d9cb9f66ad1117e7227bfd452988ff7127cc0d7e9d9cf3b1e5c40ba59a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ff60d3214e2f6831739f93277800184895ec948fe5577d55b5fc7a53990720"
    sha256 cellar: :any_skip_relocation, ventura:       "3f9a38eb74e7c621d6d06c56a5093ae7072566252f9d92504a33e0f8d6c63669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a15e00d215ac5e7ad726ed91034b446df6cf48cbea75ca3277d79c88fb146b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end