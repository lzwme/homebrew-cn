class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https:github.comkbknappcargo-outdated"
  # We use crates.io url since the corresponding GitHub tag is missing. This is the latest
  # release as the official installation method of `cargo install --locked cargo-outdated`
  # pulls same source from crates.io. v0.15.0+ is needed to avoid an older unsupported libgit2.
  # We can switch back to GitHub releases when upstream decides to upload.
  # Issue ref: https:github.comkbknappcargo-outdatedissues388
  url "https:static.crates.iocratescargo-outdatedcargo-outdated-0.16.0.crate"
  sha256 "965d39dfcc7afd39a0f2b01e282525fc2211f6e8acc85f1ee27f704420930678"
  license "MIT"
  head "https:github.comkbknappcargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d34640c51d476d3c0e3edffc99932c71e213f2714d3aaf23d58109916bfe637"
    sha256 cellar: :any,                 arm64_sonoma:  "1771e1804acfe1537233821c9185975e0061bca378a88594682fe11d1f0ff032"
    sha256 cellar: :any,                 arm64_ventura: "f188cda8e578bb128373a2fa2703a8682cebe9b570f798b541b5bdb84ffaed84"
    sha256 cellar: :any,                 sonoma:        "5fa2feab40497eb4d6f4c82bcf23bdac336159c46c027ac2c7b88e547a127e10"
    sha256 cellar: :any,                 ventura:       "01ba35ef314267282776569918241939965bc829c133c8d11736a4c6b0b2847d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34bc7ad70d3828def2fbaa0a4849105339300d72ba4abc0fadc3269fb0fbf8b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end