class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.109.tar.gz"
  sha256 "f3cf84703796cd413798c59552e6eaebbe18b7d5ac75106e41837a46f22891dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b10d02f7eabada4fb1a8e1e44f02072dc6a0a6c18db36e13c953d2ba0de812a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fba2086eb6aa64fe430feab9a73db9284ec023ff59759323d95b2d7ee7b080d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdcbcfe2313b08f4a503f91fbbb41fd38d76d5397869123717fdc027340dc404"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbaf5ff15ccd14d13af2c5f12adea2ab215f0b73ec216839c90a1b44b34572e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458e7d5175fc38f085ecc5d799fe62ea58fcb0ac09b6f47da2fbc73f7a4113e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9baaa6158a7a0023d4da62311026b83aed2cc027db289edbdaa9925f1d0233"
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