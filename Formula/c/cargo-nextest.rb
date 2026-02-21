class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.128.tar.gz"
  sha256 "8e42c30c132a2d7c277d6141654a5990d5742e9978e91b72d69ef33fd996ba82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2db194e80ac48002a838741206aee0a5706023f0ab65043f843a5f1afb35c21b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b0ccdc312d40366c55405af952f52094e0d6a517030789ebf35bc04fd4955c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ed08076dcee79fe10460d53bc50802532cfca1390fbaa95231f0371ac096dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8ccea9d4e821f8723b8684ff872fb1f5e2e5fff38af480a9178529f7e864ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c320f536a6a04244f0d46ec2d15215f45a4da468e6dc48687859d630685f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caca4883f3683a6155600b3a25b3b69330da59a5ae2937d302b7190450e9a43a"
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