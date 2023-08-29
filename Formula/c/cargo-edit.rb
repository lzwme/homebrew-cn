class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://ghproxy.com/https://github.com/killercup/cargo-edit/archive/v0.12.1.tar.gz"
  sha256 "2223107d04c17643ad3261fb2c106200df61a988daa8257ed8bffd8c0a8383ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f5ac5c34c0555d7c7fa89b210a3423850705960053a272388bcfbe57ede2f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9854f0ed61d660953ceaf6cb20a6896468662cee7253ccf0bab78b7bd17d7859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a74467ac2a0be3c788a287da9a4da7e2718def4dbdde910fe78faf0e7f26a9"
    sha256 cellar: :any_skip_relocation, ventura:        "d5300d085be7d34dfad2b99438785ccb589c94bf4a3c522b7d05cb39808c4146"
    sha256 cellar: :any_skip_relocation, monterey:       "8df12fdb7ec5063d5dbeb2ef86ebbd89c934b438cb7cbadd48c12377645e11a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c9856ef6a06a266d8913adf6d9e30f5b3afad6d1aae69dbb223e0d40a52e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21764bba2319eac641f01c4b9244350a90829eee27aa11f65fccf90be722d7b5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Read the default flags from `Cargo.toml` so we can remove the `vendored-libgit2` feature.
    cargo_toml = (buildpath/"Cargo.toml").read
    cargo_option_regex = /default\s*=\s*(\[.+?\])/m
    cargo_options = JSON.parse(cargo_toml[cargo_option_regex, 1].sub(",\n]", "]"))
    cargo_options.delete("vendored-libgit2")

    # We use the `features` flags to disable vendored `libgit2` but enable all other defaults.
    # We do this since there is no way to disable a specific default feature with `cargo`.
    # https://github.com/rust-lang/cargo/issues/3126
    system "cargo", "install", "--no-default-features", "--features", cargo_options.join(","), *std_cargo_args
  end

  # TODO: Add this method to `brew`.
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
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-upgrade", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end