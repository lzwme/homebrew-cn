class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.93.tar.gz"
  sha256 "319bc72fe5479d0ce9496fa03bdf87e04b335490c446272f7be2912327b1145d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d3817cca71c9f80d66c5aae5d1e284b54c148237ed0abdee1c19baa9728b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3983ae289cb96bb493ed118a686daadad422b902fbb7072502c03a1a45f7d93c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1237009210b10b5670d7e924904990b0ebd88975a3ad7069e3c5e2815a8feca9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1549238f9866fdaa3b32be01bf5adfa163744e310a9c6f906d1fb44e3173b871"
    sha256 cellar: :any_skip_relocation, ventura:       "8e7f5613f44073d97d2e21bb893ea5513d9f9f859cf9a3a940bc817606cd2e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6229ef742bc5d3e810645849a50b599e55a7dd4a736f8871f0c5c94c10f56a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128ea9b2d4c25f1c2f52cec76ea9bf382dbf551cb6db17ccdb26fb438bcaaf5a"
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