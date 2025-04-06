class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.17.tar.gz"
  sha256 "38dc83a5307492fb3d0d03c6c8eb3f8fd38e4a89969e86085d429c75071007dd"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16598e6d4d41c555924f05a4b86130bc187b98628c6d96ca4bdb24ecd3545740"
    sha256 cellar: :any,                 arm64_sonoma:  "bab34ef26404da40da0141120d913b37b33f9305a7d6f01d26bbe98ee7619a40"
    sha256 cellar: :any,                 arm64_ventura: "d7920a0233d80e2d6bfb5c10b24b4e35a6c10dc3b932e8bd0fe118f1844c4cf0"
    sha256 cellar: :any,                 sonoma:        "9612ce2f3d8acd5733d9548dd808ad17b04b72ea10deb0eae900335c711827cd"
    sha256 cellar: :any,                 ventura:       "dc919f2113db68ab23f762faf9dc51a5a8332dbb05eb19d59f71bc124af6b76b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263aa299d0f67095770718678d14a20b9fc01ef56360ebeeadf57db4ca580347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a64e1478de47beab391fe6b3f040e8c73cda7d9d0dce540d9b07bc1953c05282"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  # libgit2 1.9 build patch, upstream pr ref, https:github.comcrate-cicargo-releasepull876
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchese43c3d5d867604166cbb95e241d3679eb8ca61b5cargo-release0.25.17-libgit2-1.9.patch"
    sha256 "025e39c2bd6c8112e7528986b629a44d84c6d7036e2d1bd2864e650ff3156c60"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utilslinkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end