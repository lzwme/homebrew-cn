class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.117.tar.gz"
  sha256 "f654ad6e3e8f48a7920da8aaebc24c6a2c02b15d2f1c4ee20636ad036f90d592"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345812dc4b7dbaeab20fecb06f90fe134d938d5052c567572c345a06473c316a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845796bfcb97507858a19bfef14cf7f0c212d43d292e4570001bae10ef576bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34b99cf2062da295996f3c3af36487d97dfd48396909fa1b2f376ec92c81a9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78e6f8f1fc3867249de9747cc6a6158a0bab5e1f31197adfa77e305c06494d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f12310aa9c0a86d97ded09397b2d180c69c2d2f29da38e8370030d5e59ce736b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d272f83e57efb55543d31a5820c4092b8260e1994e49189cc3bacfc1575ebb"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end