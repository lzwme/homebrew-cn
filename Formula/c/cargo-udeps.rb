class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.49.tar.gz"
  sha256 "f3beaaa9c11526f4fc52dff140214b8948622b69ebf2878a607132056e6b3c33"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d26fff7e646a5447d6ccdafcb6899e17c91f60fbb3ae27b36fd4c3c818b526e5"
    sha256 cellar: :any,                 arm64_ventura:  "d61d285c78243004c2b66065b50096a43992c16af0214e8e49d15c9a9bff742b"
    sha256 cellar: :any,                 arm64_monterey: "f24b87ab2bcd523df1023c42ba8e73d29f46b3e30392069ea50e6bbeb62ff7a2"
    sha256 cellar: :any,                 sonoma:         "e7af5535059df65a1ae508341be4ff5bff40c33632c009fd9a4e54935d9ba569"
    sha256 cellar: :any,                 ventura:        "b7a614c6faaf213d35134f997a6fe06ecc3bf5107778a8f714ba0a5e34e6fd36"
    sha256 cellar: :any,                 monterey:       "7a4c1b7a7726c30981ca6dbf1c9869a725d746db37d935a066943fec73a98ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca6f9dbfb96bc0cdb8d408bb8bf0ce7f178d6e7f5671252d885cc86a326d9d4"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write " Dummy file"
      (crate"Cargo.toml").write <<~EOS
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