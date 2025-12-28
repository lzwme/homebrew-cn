class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.116.tar.gz"
  sha256 "02deff6ac470be7aec82f082465892a04510348dd67bb549c1cd0e3d323a71a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37c8349f6988cf628181f04cddac189472103424dc838b4e8fb24380c2ffcb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "128788b92c2e6da6f26306a97074a880fb3ed105bd836443f12de901325b8a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4bb004c32947dbca4065d7fdb0d7c0f05e9f483267642fd3acf55963f86373"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c802fdf3a6619ca9543f4eb645a2b9c84776e82c6894a8a3262bcaaf518aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14f5f08ec48a94f9fb8bb53b8d40fc5580ad6ee53ba0c0107726fdf20d06061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbbf21d96f6ed51e38658960fd158f54191c919a3457c388c2f502fa5bf71333"
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