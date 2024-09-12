class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.78.tar.gz"
  sha256 "cab5f307ca28cca63ba577614a41a7d390731571241d0460e005e2b32d5efac6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2164937f12035011437c08bec68536d978f190ee812b6ca787dea5242253ee17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76849e9c398276fb5ea0ee356c0051d0785fabf0f867d7e379afb6338d8e9a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2774861cbba7ce18503d131d46bf3b478a348565fe72bbf21922b150ac2a33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a69f08d55ef853ed7ae56c409b97c49f6cca2a7d887453d1fc75ab09e67b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "426f3ddbf21d5cbf0e9c7215646d28b812f05f2002eee9507279dbb6cd6a0bdb"
    sha256 cellar: :any_skip_relocation, ventura:        "3ffdc1edd3a51b6a793ecb5260473300030c92655f41585ff2da249a032604db"
    sha256 cellar: :any_skip_relocation, monterey:       "e30506fcca60085968eafa21f19704f33881d3fdf565c24d5352935c07409e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b06221fcf62c03a5c77286199c5a1b29065c141bb612c27517201bcecc02647"
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