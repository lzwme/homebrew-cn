class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghproxy.com/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.44.tar.gz"
  sha256 "2ec238af19b352933a1637fd1fdcd97403eefb8cc17e6f09623bd3f207cd828b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52c2cbcd796a23ba6d64c59b3b58ef8fdda8acd2d668148a86e373ad34aa7127"
    sha256 cellar: :any,                 arm64_ventura:  "c68f756823688a2068faecbcd2c12cda0513c8200c4cef41bcccaa9bc5c00dda"
    sha256 cellar: :any,                 arm64_monterey: "0e4e2f9a2967f6b13476d05bf42d8fd523aceac384bb1907add3619c885bff5b"
    sha256 cellar: :any,                 sonoma:         "3d92f7035798ab31859bbf0c03180931d678885c58fb129f782a8ce7cb98994f"
    sha256 cellar: :any,                 ventura:        "a84b4077640ad6e2b054a625bbdccb55abae779dfcebe6ad987e5f51660526a6"
    sha256 cellar: :any,                 monterey:       "d7a6fe98243a0e1c1b9849b301f2471c55a31fd5715d7cc112e555e92245d785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbf1b2ebf1b7e57010396665f939d100318d8de6530596048c8695bcb7162adf"
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
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end