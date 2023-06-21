class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://ghproxy.com/https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c66a057df87dda209ecca31d83da7ef04117a923d9bfcc88c0d505b30dabf29b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "a7d8b0bbce01128c6454b83c8e05b7fd7fb42b45acb9bfc915d2d94b43e328fe"
    sha256 cellar: :any,                 arm64_monterey: "b020bf04b070a93cf27025277aa3ba4507bca25a66eea4d8fd7b3e08d6e8dc22"
    sha256 cellar: :any,                 arm64_big_sur:  "4291c85bcaef611bfcbae8c371680b0b31fda91a98cb020eb4775f52ec2b03d9"
    sha256 cellar: :any,                 ventura:        "43ffd254c39a645bbd2751396bdc0d0dd690482c79d36db36479dd0017b8279c"
    sha256 cellar: :any,                 monterey:       "7f05bcaec33150dc32b8e686a75aac7f73a843af43cf91df90045a075a84a69e"
    sha256 cellar: :any,                 big_sur:        "b43128923d4d39d435d3f60941f936315576088a8ae9390b3735d63784e9684d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0331e513f5d9537003dbf681b08226a10c1209025d60e1b3232f02bd079fdb39"
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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