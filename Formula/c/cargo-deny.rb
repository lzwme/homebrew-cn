class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.5.tar.gz"
  sha256 "48e5c691dfb246c37a078381b7d66300d9173fe7dbcb3bffeda81826650c5f40"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6864b5fb7f28565f840a792573e65eb240cbd0efefeeec20ff6581a8b59d0be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6d15440d230f14fc548166ea5c6884c951ba0a9a7556dc0b74ec1244384636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86cb948e2873b1b3fbc6d6c45cf92940197d3a2536938ebc47ef77686587a8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b08f52de1e9ddc1d5ffc641d5af915154d6f3397b7209cbcf9543fd1b57f102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c3482efb1b3e7f58f681674b13b400370d99bb9fd2bdcd56b7d56a4e4be879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998fefbbf4e6abe31e47cd650fe345f6b034315433f01861d025d70c2c5f648c"
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