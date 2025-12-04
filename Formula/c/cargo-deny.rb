class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.8.tar.gz"
  sha256 "5cf5aa23adf6aba980c687c8b79c056afc79e9ad117b0124dab183a77ffa212f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f28b99a899562cb762d54d1e955b3c840c5874b804a9d9a7576d2d171689baf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be097a3f379deeb37de67b92ca4689339b28d19fecc75608e8d718fdfdbee90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab2aa42b2c133ec501893724335b378af48b1ed20abfc0e9673b147084f2286"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a01498f2c5a387347573243f9a2e76cfb180052a91ab6a75e5253581d8e94c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f9d37dd1733f02614d52b8f5a3b40677c2416d3363302a20408852ed55419c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd2e670819d34b53d68a82ade0a6d3dfdb5e34523cdae8395018d70b8a23318"
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