class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://ghfast.top/https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.12.tar.gz"
  sha256 "8a009d9c81f9f6808cb30ed88c6a4572c54343aa34032dac995fbe76792c040d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da53ee87e64535a2434b6100c8078eff1cabb1cc311fa23739c57be7f72c17a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900a2f679d5507b814197fbb8fd25db01a72a930db824f31dd78df4cb2075d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ff911d53bb8abe6b82d01b692997d207dd596bd20d3fd5a28c261da6c4ba419"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d667fddfc01b6e09b6ed900ffbd43c57e16bd65e23a6c6ac9a6b4348a99b4e3"
    sha256 cellar: :any,                 arm64_linux:   "98760a7bf5f95a6baee64673188d70677085db648115688d64ff619f8c0d62d1"
    sha256 cellar: :any,                 x86_64_linux:  "e1315fcc1ef06a9f5a475ca53ddb1239e9cb2a330da39e033275333cb12d03ed"
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
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end