class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghfast.top/https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "0000ac4540ad506d5d3ff4e1b1b3e487d644e21e3a3a571995fc78bad863cc32"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32e4b0090a58cf75a3be680b8bca06cfed6b8cccf473ce0b15ac9f3b6caac5ff"
    sha256 cellar: :any, arm64_sequoia: "02bb1c8452399d74272d766a683f1869771360bacb92c304a520242456536bc5"
    sha256 cellar: :any, arm64_sonoma:  "00f9b079d2c0af1bc481b8400ee442de5e08a8033e6747ac3aef2b6b13cd6b12"
    sha256 cellar: :any, sonoma:        "54bf8d16b9f4432e8b8f8002948bfddd0d7949260a09491049a37a95becadf5d"
    sha256 cellar: :any, arm64_linux:   "c83c7958b14a88eb333fd6f6be78a1bf03dddb02cdba9d541344d08ed65dbaa6"
    sha256 cellar: :any, x86_64_linux:  "1804a2d5278ecbb2b54006824ddb1b28464533eb19504e01bcb08bbd0b2f3c2f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end