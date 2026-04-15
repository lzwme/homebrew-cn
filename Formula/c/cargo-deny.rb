class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.2.tar.gz"
  sha256 "9d75ff0e129a0ab8e09e37d0be2cb1dd21b077c7c589f55097f710707d50b2a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb93ebfb2b672ee5b41d6df479ebdd22e743e71579bab53c7ecc3186629395ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94a7de275d979b3d8be843f4bc199bb147ccb965b9dbcab1addc7f6e92271ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c01973b52d8cdeafc8d572456eb3cb85a90c01e0014ba964924728b29104b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "d386de7967f3dfa164dc1aaa7b16fd0ad527e08f2d32e290067e7dbd3a66383a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d06cdacb040adab267a7327731b1e14ae8ec86dbbefa5f91cd0a19e174bb088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91179e01fc550e174b892f9dd6f71fb717b3f20c18ae0f023459f13f967856e9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
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

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end