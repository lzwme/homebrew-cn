class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.110.tar.gz"
  sha256 "12d272059ab8bdbfa9a30ceeacc249b2f70783c89a8abc60bb212284cfd21bc7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c796d2f0bada7791ddf6d829300a8f135004353496a4b700245e2cad698f78a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e332b22b2d47057b3e1fb79e799c86ac8e08a4b4e0ae423a5acc63cb8cb8338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b04ece159a3d09de7abcb88ee2f0616ce179966898e70962e52f3ce1f391f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2b840381823c3bc717b4b3970450d74eee39a477b827aa79dbac5b71f8d082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b04f3202f980144e835bda063beec58882aa930cdb899542671c41a726f0b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "508b9bb7d1217d3c0b682995401ab32394725582c450fe9e6f7c0c723effe087"
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