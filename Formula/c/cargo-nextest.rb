class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.91.tar.gz"
  sha256 "673b7a7dd3f7f9e3fd44bc466ed4fddb6bf1498ab83ba4e0e875b2393b8d668d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17d23bc4151d826be36e22fa48195fbd0221e8a0c9d4d8ad92c62c69216e946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63712daf7bcc7231dec82156ddb681f2e8c357639525dbad2863cd4fe5a967eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8a1d67927e1ff00f32ce070b8f91e5fa3c0b13f0e80225561c535185b6a34b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e92435ed28fd6207107906e152db1eead4c747a8b7e2e2ffe9cc477a41ac6b"
    sha256 cellar: :any_skip_relocation, ventura:       "aefdb2825daf4c467e3a85f0f127966657453e0308c658a333c25f307323697f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9b2342db37cb0e0b4906d1bf2a6064d2918aaf5c26d6188bc40f8925c25d61"
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