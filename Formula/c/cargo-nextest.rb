class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.62.tar.gz"
  sha256 "d3d412911da8701743a3f5833e8c188b5183cca3abadb2cb97d4eb28df9bfcf8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de30a15958f30ab05e66356f7468e509a23a68e8e49189a4c6710bbfd4d9bf4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2072232e59593636f12a3fc0602960355e24cbca84a63aeedccf4c2c1498c6cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd9a320ff0d33c41bab6d4ea6d4f40726df9b37fe87815c594b94a2f779f9a21"
    sha256 cellar: :any_skip_relocation, sonoma:         "5555c009e4b28f00f2e31437a890138e78f88aaa80be9f7b956d21394cd56231"
    sha256 cellar: :any_skip_relocation, ventura:        "f90d2c8981730a13aadeb776f0de9f8d501e6636d2b544683ad7396850ee6e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a391909a10ad5490c49d539fc14336d7e618762dd1ee804f0a334f0b0b2b3319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca977e03813936dbe289ee5baa498b41e775bb3e0e63e882c9632cbddd1da99"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end