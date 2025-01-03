class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.53.tar.gz"
  sha256 "fc4581c996dcbd8a9e660f49a55ada68e39c4b07a0eda9bd8efe1006e1dd1c73"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1fb68cf1d9ffdf5e6b818d92e2233bad9cca8a8c4c0d6d650cf9e5215d8e447"
    sha256 cellar: :any,                 arm64_sonoma:  "cc9ee12b128e941caec64b271ff436cd8de98be54f5a7d327eb56d76b8897d42"
    sha256 cellar: :any,                 arm64_ventura: "463e45fbfe269b9d7cb78a1ed9e6f9e37d0809d79014c7526636a880f8118032"
    sha256 cellar: :any,                 sonoma:        "2cb29b8db03ba0781acea4b3d023e8355570171947c6658b6f366bc65e153fdf"
    sha256 cellar: :any,                 ventura:       "67e6378019d16e0fefcfae97d225ee0673834eb24269884a3793df4976b7bb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3734990ed4b83f9d2a85d6b675e3a25d0b3bded7cb3a5f7d29ef3b608768c0e4"
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
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
      assert check_binary_linkage(bin"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end