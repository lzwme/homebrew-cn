class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.80.tar.gz"
  sha256 "b6b6907ef4ef3a7cafa4c3f0ac468d27fe782f94728a8873c6b2e274304c4de9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c82a8215db9ddbf5c380f27743a984d794fb1942e03cc9c19101a59b6b840b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ca6ec693668dc09fb4ce6125fbe89e90488ff9ce424532d0f3cbd789e03b7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1a7f6af33a7521659d4174e993e6e99d2bc6ace0d697188e2442b0102651cb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c993dfcd0feef02104bef97af9432dc3c14f663dc873227993a1e9b5462a9baf"
    sha256 cellar: :any_skip_relocation, ventura:       "6684a1b932736d56b45874ecf23401f6abc7fed472e059a3bb4bba1efe4b846c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6944c773fc304849c72525aad28ea2f103b5e3ebe6d61ccf9ef42653c388de"
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
      (crate"srcmain.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end