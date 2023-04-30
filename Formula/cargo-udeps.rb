class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghproxy.com/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "937e560c91e29ab9a9455ca511c1c8ed157418b11947e42672c6925375503ed5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2b46d1db18cef77d22812f2fdbf2d41353ba1963a08c6114b1dbaab6208d932"
    sha256 cellar: :any,                 arm64_monterey: "6fc111ac42983efcd3cda860b751e176baeb4eb5cfb4aa2a50b374ac6c0ffedb"
    sha256 cellar: :any,                 arm64_big_sur:  "cc0aa1210d3227132dc6543381e9f957ad679664da5f318179203c72ac262157"
    sha256 cellar: :any,                 ventura:        "58ea0be7b38b95587139f792cadd785fe6f133ac1e977eee500754103d2fc40d"
    sha256 cellar: :any,                 monterey:       "9837179771683c9195db4e3a7bfa44357fc6027469e7318df047645125b3bcff"
    sha256 cellar: :any,                 big_sur:        "637887893d9d7f986064ba13103dd5369b45619d81c81613c1b1554154c890c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a4edd7d9b35324fb10be4f16f71101b21b1f77fc9663d6c65833236b27b6bc"
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