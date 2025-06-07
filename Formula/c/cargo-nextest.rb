class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.98.tar.gz"
  sha256 "f9e28ae36085ce13657533ca8cfcdcb678b3f5dc6e5589572f46911f47694571"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "930ad382afafb2209b8c29fffb78b76a185a9915208b885dcb80ba41bd7619c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8fc1a65e990aacbbfe3b404ee501c62fbe687bf26309d4b8962c46683f0232"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6aedf633baffcfc376614f78b4bd86acef6176709734cd34d292a7c362db2b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c38fd4a3c5e32472efe8fe6253289966967baf29d3b63abb89b2086d1441ce6"
    sha256 cellar: :any_skip_relocation, ventura:       "b162ec147a7bfa0bf8d1aa997cb6744fc44841115daf2b9b2beb3fec7e7d44e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83c8ede526bca605030d929afded2d00331f5c316b1424f48c0a1a291c0fa54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadffd8bbf5520913be1dbcfe5f1d5bb7124570c39ee20ecea40fa5f06957f9f"
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