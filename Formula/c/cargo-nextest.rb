class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.99.tar.gz"
  sha256 "3a75e2c0bbf4da7a3218c772e8a178939fbf7fea830f6edbd9d37fe023a3cbe9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67cb4e89f717279eedab13190c085e28c7ec5df7d389da19efdb78658cb0c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae7f7def049aa36dcd6178fddc042e9be97dfdf823f2558a4337f05d18499be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83f74bd1a4391d073dd5efd32e843b37c3e534cd875678a8dd2522ed0bc42ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "626ad5cdae38379e886e30f9eb7f683e54c5b49d79c7f35cbcbd1dea62179d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "25f3de28660b118b9b978c1792767683a6fa08bf6569684a41ebd16a7fcbf3e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382f8b4ffd95e61161069ab08a054b2ffbd63258b3a83ee9a38e6b5eb3366bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63eed09256fa43963cf71ae19264caa54581d13f5c0d72dcdadca46f9e25ed0f"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

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