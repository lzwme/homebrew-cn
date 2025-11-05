class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.111.tar.gz"
  sha256 "7d08bf008e25f2d843efb8add9aa8bd8d48439282511fcbd5353e91eacae7e98"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b56406b1803156a883557cef04df9dae7894fca3b097fa44786f7b907d395c89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdab0a93366c68654f9fb0db107514ea745f42ddb98cf6316a85342f0e79f9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b435ff677c3591a453165aa7d3f45bdfcfc8e582c15584633a8e21d6bf9c11"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd663dde34c1205e23041ade4a976848e27f3461e2476af94499893779960e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1079bc183d17a8c749095d32e20567a43fccb3d606e0b513b8b0f1884ed81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9893b52188ccd68309e07eac7127bd365ada3e9be3ec5c8ebe2716548aca687"
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