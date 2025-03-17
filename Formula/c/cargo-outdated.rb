class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https:github.comkbknappcargo-outdated"
  url "https:github.comkbknappcargo-outdatedarchiverefstagsv0.17.0.tar.gz"
  sha256 "6c1c6914f34d3c0d9ebf26b74224fa6744a374e876b35f9836193c2b03858fa4"
  license "MIT"
  head "https:github.comkbknappcargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f07c8770e65c22709f66c88803d731f49dae9701d0cdb09e7a03ad5f20975b5"
    sha256 cellar: :any,                 arm64_sonoma:  "70fa28d6d29ed7ffc72e9af5d542b2667ccddc786df36bed40fa97f5cfe12481"
    sha256 cellar: :any,                 arm64_ventura: "b0b0f15665c9067c04f268639baef2476eef8f699cb47aa39e63d543186cf072"
    sha256 cellar: :any,                 sonoma:        "30888f6e8ae69512bf0486d81336aded2f20af9593cc52311fc1ef7f41788e2f"
    sha256 cellar: :any,                 ventura:       "1d6290123b277fcf587e45778af8bdc5a5fc3c8426c416a67c633c9f3fb931d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3987240911e43c2dc506aa9d1ca75e41867554e89e40536da5825aa060495059"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
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
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      TOML

      (crate"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end