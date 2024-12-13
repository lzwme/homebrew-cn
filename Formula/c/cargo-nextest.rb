class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.86.tar.gz"
  sha256 "9c6237e8bfced55848b9c03166a89064905aafacb1a02f64a271b0cabd323719"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891f5b27e343234e3d1737ebdaead580a7823f9a2a0293e6805c493c7843f2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e71bd696af66c23583a36778f05cf7a71b9a424a3f7391ef63e0194c8a866e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c952a07bea55cecbed8d7c4c7391cee20ac16601e06419053ce48e6fabfc795"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a2fa1fcf9995b4c9a35142ff2021e1c594c7d4aec6f5e1dce332ba21be2314"
    sha256 cellar: :any_skip_relocation, ventura:       "5b95a80df5024e3b06208a752d1398d73f2ba41b6d5b9324e260594e2851d86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c9524dbc8b216aa079cac967281565faca12542a308066de0f342cbaf8fae81"
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