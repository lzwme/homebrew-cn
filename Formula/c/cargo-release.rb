class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.16.tar.gz"
  sha256 "0bd9cdaf9ba5d964f62105ca0d851fc5dbbc433efe352680d99a3ffd9ffba767"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7ef21e8cdaa8db34e0f5372d40512c3c2d5ed52ecc15d81585342987c547178"
    sha256 cellar: :any,                 arm64_sonoma:  "ba2338dd9f24ba1f90889034f5ab458ed9d31258864c4073e754120e02412af1"
    sha256 cellar: :any,                 arm64_ventura: "a292ae824cac262c897e193e37aa941ee4bb7f79334fb29d2fb42d404e603f71"
    sha256 cellar: :any,                 sonoma:        "8c20d6513cfa91404f9dcd63bf059a41e4ee4a2ad36321007d680ec2ff0e06cc"
    sha256 cellar: :any,                 ventura:       "07b197f9208dec38e52da22715173078e48b061d4a09c94a133304befd3fe26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba30daf1ebd78e5c785b085538077a421a7aa15b79ed01615ad6cb8ce343d633"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end