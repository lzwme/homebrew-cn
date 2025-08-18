class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://ghfast.top/https://github.com/Canop/bacon/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "9245a68cf1aa29ba33e9ebc1980bbf41a932f2a2d69de8d9d72ae9719ab4d04d"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11b2fc082e071ddbb6d1a7b446ab6ce7f2bae0c0ee150bf47f9d1d007b713976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adac7963f749aaf9e6cd187a0e48a6bc829e5a57ff622b222e56897eb0b195af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9f8d4b4586b18dd5768bb4869ced362ccafcc50899383826270e32dd09cab0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b52c67a7466c5c04300bd4627dbade6b008f355ce62820367d37e26f501c70a3"
    sha256 cellar: :any_skip_relocation, ventura:       "b48c2ece2517cfa9b051bceaa979197f288d204d85825d7314109a0f4a3f7186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7929f48df23e81d0126512fcb54f0d28cb217c063d25ddf6edf0c77659d17f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8f9d0822a0f578e82c2bd3eb92ea5aa41fdd100a394aa9354da4355723ff29"
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