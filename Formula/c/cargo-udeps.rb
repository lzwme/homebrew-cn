class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https:github.comest31cargo-udeps"
  url "https:github.comest31cargo-udepsarchiverefstagsv0.1.49.tar.gz"
  sha256 "f3beaaa9c11526f4fc52dff140214b8948622b69ebf2878a607132056e6b3c33"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67eb1c057ba9b46e113a5bd47847585cfec0c90b93b8388969dcef32307e595b"
    sha256 cellar: :any,                 arm64_ventura:  "d80c26149576935bc074057923b43230c66c7d574cb0c357e39b82e006453e3a"
    sha256 cellar: :any,                 arm64_monterey: "8d5c23f0d320e85db80e160de3f2d021bb8eeca9649357bc51fef8de40ef71ca"
    sha256 cellar: :any,                 sonoma:         "1915e5f9ce824e8555d5a25e76b18ff2152fea14dbcd1c1a0a4354d4218cbb01"
    sha256 cellar: :any,                 ventura:        "90c1b9b12a175a587cd99ae508bf4132c92aac058268d9e3ddc78d622dce11e6"
    sha256 cellar: :any,                 monterey:       "925e5a66dc1d4d04d67c4f178f07d51a60257efe6cd63998320a390da183bec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "974fc52deb3edb281e1186d213148420fdb73f33c12e6dbe16d4bcf1317969c1"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"
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
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end