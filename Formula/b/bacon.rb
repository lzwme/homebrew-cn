class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://ghfast.top/https://github.com/Canop/bacon/archive/refs/tags/v3.20.3.tar.gz"
  sha256 "9dcc1a2e250b1c9617845c0f223a0b4a18cb37aa8c2c64247ffdd23e8e41e10b"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9000f3fb86aff70d76843400041709883cc4594bd4efc1555fbfc4dccbebe5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad46706f4e8d38c987d1fc62997aeb24f5959031a9f3121de48ea7aaed26a67d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba69f309c22d66a7da8d2752e5d56803602de9d7edd95e0826c11ed25833b06"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2172c145afe5ae437979ae9f12b01dbed5479f628f3346bfd769e2b7c36cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616e7a8629b4b114dacd37e9d18404046e29fafb3dba76ac2c79062c23ac1678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf3badb3d41a28f18489cc4b30c63b7603af6c9a619ac71510355be8fc6890e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

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
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end