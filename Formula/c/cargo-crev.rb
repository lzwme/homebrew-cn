class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://ghproxy.com/https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "1eed9427b732e6d8afe9148a868a4a836d1905688c9104a2d6959fd0119795fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a1c6c3e17ca3697db7d44ef6cde043c74ab2017c1432e65ad9f9a40a5641f2d"
    sha256 cellar: :any,                 arm64_ventura:  "9579ea444a26d1a18e3fb754151c991dca64e409ba92dc651da5cf9368ec938b"
    sha256 cellar: :any,                 arm64_monterey: "ee37a502e2f5b9fe1c352bc2ec6a472ce88ec0c8d96e0095c928c10336a354f2"
    sha256 cellar: :any,                 sonoma:         "c8cab6a4c42c5d1357eef66a5bf08346928a306106635f5f287f914cf9aecefa"
    sha256 cellar: :any,                 ventura:        "6bbb48f3dd6bfc8202d4c9f4e25ad13ab27a359f1d78ad54eef5823d543c2fb0"
    sha256 cellar: :any,                 monterey:       "531217783add788e031bc09a89ae21552cd47a7ae01766cd011b3252d50a9e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55df15a0536609d2ee66ca4e7abed7f6d9bd4f6ed976babb3ed45e6e638a542b"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
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

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end