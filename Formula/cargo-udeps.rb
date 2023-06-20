class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghproxy.com/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "7122f08b9dac152c6dddacd2610aa973807037f2a2f1d9042de4bcf17d344471"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b6aa4e528926bc48b9f50aa11c0c4677b0933bf562e8b6144c08996762422537"
    sha256 cellar: :any,                 arm64_monterey: "b4b9d65fd6403a44b362ad27ede4999702a4c9973684f5458f6c59c9f54808d5"
    sha256 cellar: :any,                 arm64_big_sur:  "b3ce581a44b0ea01679a0b192d71afe3d0c8a4719882dac73dd90b47062d05ea"
    sha256 cellar: :any,                 ventura:        "7fd94f7c8a3a347de016b1f92dab0e8a51e836ca4e4525ba8b4cfd4f749728d1"
    sha256 cellar: :any,                 monterey:       "bf8b658f56240a8b45a8539c459946694ca38df3cc48ccb010bc5489bb1b4a01"
    sha256 cellar: :any,                 big_sur:        "ac1adc5fb02b5a1506088a688f6230a0380081cfd3d57b098c78bf9697a7707c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95e108573d58231673d03ea466a39c6b80553252adf38d94ef5a992e50256dd"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  # TODO: Upgrade to openssl@3 when libssh2 uses openssl@3 as well.
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end