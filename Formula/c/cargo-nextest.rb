class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.79.tar.gz"
  sha256 "21b9ca487e5b6abb3cd984b5b8fe72684d3385f31ee9a65ad8dd4fa289313c3f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef347084b8c3eb6d1580cc882893b90124ae191f5749b0ad236a10d02775435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895ac03a5b15458449d2a370d29b87452bbecb77c879029caefde83dc9787d98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "528955ae09df5ef88502ac67ae4b2afd8aba6cf4049c1959d87368d265f75887"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6155c7b08c611a6868ccc7e75ad36e6b1d9f9e603d56c36e9d00ff08fab8916"
    sha256 cellar: :any_skip_relocation, ventura:       "0e713539269885acaaa0e991ee691d49f2e824313e5439990eb19121883bffdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7eb0990215073b992276f06c27268c6b01aa6dd3764423f45e15b55bd51dd61"
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