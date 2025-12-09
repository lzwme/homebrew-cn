class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.9.tar.gz"
  sha256 "e08c9e54c9493a6e8c2b7ee9ffa73909d33e1b22e49696102aee8559fafa7c93"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "883b5f6e31c52ce16b1f5e38b5e023823bf014b3de26f4a894482306732f084d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5524b6117160d4b85247fe782c97a658615fac9fd05068a6d5bd30233a53351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6667570ade75cb8b30d3ee84dcad8695cb3bcccf154cfb05fb995e03b2cabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c18d63a3a855854edfc810b5b8f26f34a08c13594732a061e0e8218a379c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762800f9f180f726e1d5c05e0a00cd93b192d4c693ad281ece15857d8f437d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fec7ce1285c9c94f672fbcb1b580b46988137cf111cedd959641a2e3bc8195"
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