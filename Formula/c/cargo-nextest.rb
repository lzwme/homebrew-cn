class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.92.tar.gz"
  sha256 "b41799b0e87e292a8a746e18eedf2da7b17ace0e23644bbbe115e3079e6abba8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545c5723d154e709e53c38e5fa5625bd934a76d360daf676ca22b15140f6286c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0299ad2d7fb4b50e4406ba9d18dcfdec67cdc3def1bff08ebf44119294d3263b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0f49c1fdae424123e5fe5e2cff5175bc5d8a2a406ec43e8ff705c9af0aa860d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98930dee544866ddb33509dca585e2c2df825c6a1b641535cc15df98748af1b"
    sha256 cellar: :any_skip_relocation, ventura:       "1b615ba882dc252ba0bbb0eab63e1b8e74b7f341ceba8e9c0387484525e3993d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c996063ec3d6c6347a164067983f82031a0f56d1cb089677c8f88bdb426df1"
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