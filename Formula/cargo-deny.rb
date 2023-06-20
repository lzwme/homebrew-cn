class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghproxy.com/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.9.tar.gz"
  sha256 "b26d8f984e00ddf96766e25781d6b296ff7a571f2c3730a607bfde24062b8adb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "47083c1f323628b4a5d0f276ecadca3e7a6e387ec25f7204f26f8bee8fe7f441"
    sha256 cellar: :any,                 arm64_monterey: "37e778aaadf2ba3f61ad74c64c86092b656572dcdc5ab7d8b1170d0c3adb2001"
    sha256 cellar: :any,                 arm64_big_sur:  "7c1f73ff421613b0e86b0f061ad4db260625da9118ff0474020b15a1391e352c"
    sha256 cellar: :any,                 ventura:        "a9d1e8dfd53c94af9b510224c8f1d6657b99ee8ccfe6234af026d9e36dda0035"
    sha256 cellar: :any,                 monterey:       "6566f87892abe2a42b465f432ac5ac8aa2f261792ad50e194e02e06404b26d70"
    sha256 cellar: :any,                 big_sur:        "4214b9277603abe60a2ab3858999d007f9473bea273bd320f880f54433768bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fdc1f29db57642aae58a24d8d93625478e1016077eeb634231f23038da3b999"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2@1.5"
  depends_on "libssh2"
  depends_on "openssl@1.1"

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
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-deny", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end