class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.55.tar.gz"
  sha256 "bc84beb17213c69fd452d240a85697b96b167e45f43207e8f9202b5bd4277926"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "667c084abc9e6a266bf67e636a0a639353563ae250b07061f0b73e762dc3da57"
    sha256 cellar: :any,                 arm64_sonoma:  "b47b6cc533aa11dc4bb65235a7dde433613d420d12d569c2e95d4f0202614094"
    sha256 cellar: :any,                 arm64_ventura: "8c7aaf65ba61a034e24ae83e8e69dcb6d9abc5bae632a9c01045a74f237b01b0"
    sha256 cellar: :any,                 sonoma:        "8ec7010ac3faee5ac94316a16a770b39ea9f2038d10f9b29f726fa6373c7818c"
    sha256 cellar: :any,                 ventura:       "663032427fc3280d388c78ad1e7ddede092fab440f1c14fbdce105f185a08374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5c175ef1dbc2df1ec423b863c47a453e4efafacc402bd50943fdafc1352cbe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utilslinkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write " Dummy file"
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      TOML

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end