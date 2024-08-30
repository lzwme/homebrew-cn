class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.77.tar.gz"
  sha256 "91c2dac2061c5e047626b3d27cd23ceeb21e99ef9d61e9a3fad539459a501c58"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f01c34ad1ba2a66d3c47d55d0c03a9cb1b8bf13935b8a0879bd05ed7d56c1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81e2967c98b5ea4ce50b61aaadd4cf908c426154cfbd8db0aff480e6bd27f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c4fcc016b32decc0e06c8e99b0ab379eff86abd893fe68c5a4a11f845efb1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c85e9336130a650bfb6923e1db87c8a56c4b04db4544bd3125e0b6ddaa3ec820"
    sha256 cellar: :any_skip_relocation, ventura:        "a76c4ce4df08d894c5db9dc16c6fa7f22d2a7fc78f9cac905f71cf17da3d873d"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c7d7808c66a216914894547ca58d96600452c6b5fb1acd26ad5268e9244154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "045d60adfc285c657e0d84421f102ac544b397fc5feec4cbd4856364034cdf54"
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