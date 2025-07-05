class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://ghfast.top/https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "a93b87ca3b7819d4918436b37f216f50adef43c2247d1793e0ebd0ecd6e9dbdf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2f7cd3deee9604641c42451dee0e5d663bd127212145aa00a908b1033400149"
    sha256 cellar: :any,                 arm64_sonoma:  "6fb173a888692d55f0fac61b1537239fc09da307ee3871d14d33e01574271de2"
    sha256 cellar: :any,                 arm64_ventura: "5c06c4a586836d802392ad48eddbc9ca8246c503ddd9c532823bd98b3b81fecc"
    sha256 cellar: :any,                 sonoma:        "079df8951d874247d38a5403bfc4adf9dbcc2b0a5230fc7221437f97ce3ad486"
    sha256 cellar: :any,                 ventura:       "4dbf3948659f6e61d036533c648a3ee3b982d7f9d824bde94b20f8ad25647350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6142c29f98bd224dc5a415f8094eebe384908a894d8c4a80c32b9658e6139f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069f175a29e46fc6efe942306dfce55bc59bed55a97ee517cf470fd7c0b2cbfb"
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

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end