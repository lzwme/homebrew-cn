class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://ghproxy.com/https://github.com/kbknapp/cargo-outdated/archive/v0.13.0.tar.gz"
  sha256 "2a20592225cd389aeec4eec6e7a410c709d37761e68116c753f55c935b64b8b8"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ad86ee2ab50b248f1b9de974d036b2afd44b7beee2fc1b3858832beb0537750"
    sha256 cellar: :any,                 arm64_monterey: "0f689272a92f59491a000d398476f7f5749d290047f219de787248856840725c"
    sha256 cellar: :any,                 arm64_big_sur:  "7a33a3fefff752b5aa4b0f8f65eeec80bcc15d2c30527781924915f6d5b2f393"
    sha256 cellar: :any,                 ventura:        "de0b9bd89bb89b11aaf95855e3022e1d40be6a9dd61a5192843892703d1ba788"
    sha256 cellar: :any,                 monterey:       "c800d30853a37aa26187ae741f657fd83fdd2a2f471de08209822bb755c95931"
    sha256 cellar: :any,                 big_sur:        "c735b5b78db54d784d747d8ec6498718bba716d2c405641601026116c5327d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45edbf0d68634e00ad25174af30253101262528a32ca1deec952a49e95d41b64"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@1.1"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end