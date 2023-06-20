class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghproxy.com/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.10.tar.gz"
  sha256 "56aa9dbf85dc14b2d6ea6e0922fd0464f45af09e2aa26641c6db84d61e2de543"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "becaf0d2bc4a0d94a7ddea14bbd72a77382e0c9ccf8d002af01a8bd174701bfe"
    sha256 cellar: :any,                 arm64_monterey: "155fd1a7b7cd66cff3fa09d58a8ea8e7ff939eb3feac60a61334eec6715b7fc1"
    sha256 cellar: :any,                 arm64_big_sur:  "0b6d41812284cbcc42f3a4101f3d37136a7d700cbfe3795fea8636470486c8e8"
    sha256 cellar: :any,                 ventura:        "fc7bc57e9456db77fc091e390ee92b189a4a439256aa85eaf0c834580eaf7a5d"
    sha256 cellar: :any,                 monterey:       "67b05a7139ab0d4650b4e66a254122d2ee867e06f05d9b6293f3502fff596652"
    sha256 cellar: :any,                 big_sur:        "81ec4ec2a3e4d1d97206d84d417f367bcc5b2059da8fa63a69d287b899010b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83680b83660adf80f81c4c2ed349748740b8013cf453d842119499a8af585e45"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2@1.5"
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

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end