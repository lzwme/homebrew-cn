class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghproxy.com/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "bb52aacf72b0943a82d51b4fd8c0d7e07649e7f655a6b3d467980f90631a0ae9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cdd879fdf95d9fac95123cd76ad9f0a368127b0207a17f3a20aaffa39a166290"
    sha256 cellar: :any,                 arm64_monterey: "1f73e0cb517d17cc63f225623ae8d3574df73401e8fa6ca01214dabbae8dd0b0"
    sha256 cellar: :any,                 arm64_big_sur:  "058c89d0da9e6ad8615bc1cb43c372411d95bcc8a4a2e788bdc55c2a51c95bc7"
    sha256 cellar: :any,                 ventura:        "24a79eebf54c29e6963af46edec483fd919d0e1c26adc74bb954536f276010dc"
    sha256 cellar: :any,                 monterey:       "d705dcb650db2ec9d44a46174ddcf23c5b95c04a058dca4008d16d021868f2a7"
    sha256 cellar: :any,                 big_sur:        "170b48c898a8009947dfdeeaead52655ed8f0ffdc0ae9d473574e4a8c8aae53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3869bb8adecfb42cbebb43309db8cf979d14a3230fe3dbe5e1c80b36951db794"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end