class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://ghproxy.com/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "fbde90b749180128e2d4171b5d411a1895819e911bcf560264808dc610d0c5ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3675b6cb9832967d904ce2e195ed69233c4a8d176e72357129dde3729e7c15e2"
    sha256 cellar: :any,                 arm64_ventura:  "a5e01d7f5fd0aaff1155c0403393f383cc2a330f0abd297afe2955dd78f7b081"
    sha256 cellar: :any,                 arm64_monterey: "e62931f5d0cf2b56dd2add8dc3075e402a5190b885f03d9b4aae8e7d7c579020"
    sha256 cellar: :any,                 sonoma:         "15eed0a3d9fad9271b48558d4d5d2fb76075b4b073b0685d45ae115d109fa9a6"
    sha256 cellar: :any,                 ventura:        "6ca0b76f7ad7c09d1e9d685004091e429f5eb15e150cae14b8a5f762a438d21e"
    sha256 cellar: :any,                 monterey:       "4dc173985bd5c7b6f17309d7647f993ba861f1ebf5b3127f3bbb31fbc6a46521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed58418c8fbe39b5a20fb8af5db686569248f8cffd5e95c7993e78c3e37a6d35"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/crate-ci/cargo-release/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end