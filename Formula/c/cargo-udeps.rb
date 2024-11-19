class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.52.tar.gz"
  sha256 "d74e262ed4d53f584447bdc8ffc02d37bbef4484b2b4413186d7f8b255bfe5ed"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd03d0c81354a4825c40bc113c6a36e01fde8586c126574db9b38a61fac33533"
    sha256 cellar: :any,                 arm64_sonoma:  "7b1ff2f6d5f693f5acd562e0f065e6a25f753162d11b41f139739b12ef28ac92"
    sha256 cellar: :any,                 arm64_ventura: "0c16fe1dd6b9f9335d833c21bd6a6167fb2a8da4e22506a572a16e69ec6e1ce1"
    sha256 cellar: :any,                 sonoma:        "1d5de8fa27cd8df34cbf793ae9498a5c2fd6f04044cfd6cbfe80c483a65bd3ad"
    sha256 cellar: :any,                 ventura:       "334abe9cdd96a3a81e47b17d81737036f801c8d79838c9c955db99b3a7e9b827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f3b56f9d41283f711376765990805865ebbcb89687e7fe9cae281dc49ba888"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end