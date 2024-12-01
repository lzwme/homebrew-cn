class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.53.tar.gz"
  sha256 "fc4581c996dcbd8a9e660f49a55ada68e39c4b07a0eda9bd8efe1006e1dd1c73"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12be653d70676ad78cc09e4a2a0080ea7bc05dd2e26d97edd7aaa6c4dbe99dd5"
    sha256 cellar: :any,                 arm64_sonoma:  "98fc902d83ba3b52f7bff706a3adcce1c0ef7be85e97288cb8984e4057416ea7"
    sha256 cellar: :any,                 arm64_ventura: "99809e0d75a6cbeb830ba4ee7701a6045ba70e65041c9fbec44d74aa9b41efcb"
    sha256 cellar: :any,                 sonoma:        "4585400b1dd440bb929a16037ed76f714fe2b43546d976b154bcb5366ce68093"
    sha256 cellar: :any,                 ventura:       "410a2ad5bece4b3b765b0da03726060282611fb25ea3c2500619dd11d7f8e386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0f6cc7eb304b42112cf561f471b6600ff57af518c389a82713347f644f25ab"
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