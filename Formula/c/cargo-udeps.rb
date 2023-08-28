class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghproxy.com/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "b89c4ba44112a5b9d544bc8555a69f2fa24f44a0a389035cd38f19827a262e78"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c23b5b6693551bc577db0e793b2f77d976130cb96e7af5ac0f3a73c272de673f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d402c17c33987146bf3d6f7e055c3adcf41b3a7ac3cd51ce6aca9d1ee151630c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f440155c074c690de69874dfd3d913d94722f4b65899a515ac02b0c5462769a9"
    sha256 cellar: :any_skip_relocation, ventura:        "84e1cd9b4328277a0843fbc75358f19dc4935d95d053e332d8b2b196443c3277"
    sha256 cellar: :any_skip_relocation, monterey:       "eb77cf1381aa35838dfb1eb705c05d0443c561d74ae2ba380d28898d855ddc0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74fe83b2b2c97fe37ca4896ae695fd1860bf20bde3674cc862e4721abb1234d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95a1347169c1a79324cfb0660e82e0efb4a3d9fbb4c1109d0c31fa1f2a32968"
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
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end