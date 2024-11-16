class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.84.tar.gz"
  sha256 "f742e6b1c620aa587cbb10375b2ccf3e0cc483943ff84d31fa832c10b861ca5b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e18423e1b0c8608201b7a0b701348734fc51f805d390a44d3e0263bfe531f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648753e9af411337dd2f27df27f4cfb40e3fd5860d5c14055fb24ea47c2af92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0343b590bec2bc7fb405bc9eb5893f93b1dc5724b7c3892142f0bd120f20ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "12972ef764500cf7394cd566e93a059fa702e9315955a892f20d124b7fdf1730"
    sha256 cellar: :any_skip_relocation, ventura:       "b43948da0653c897df5317e84c4f4035a49b0d58275a48c7b4aca494e8926aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532d08d299f31214562f869ef9251f02deedfc84e16b7482453912c25f79e22e"
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