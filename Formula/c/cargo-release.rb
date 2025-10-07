class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://ghfast.top/https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.20.tar.gz"
  sha256 "34edcc83ebc6839b22c9fadb0d7c8eddad6703e12f5bdd83180ecc60905af488"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ec7651f8870696c6a56f558c7e082781016f1ed5135eadf5db4e7d9fc29061e"
    sha256 cellar: :any,                 arm64_sequoia: "7d6ae72fcaeff6f00d9c993b41eb733b5201802e9cdd010687bc5ded15efa52a"
    sha256 cellar: :any,                 arm64_sonoma:  "c1f61f3b1993be45d83eefc8948fa590c54a39680e602b40800de56ed100ce3a"
    sha256 cellar: :any,                 sonoma:        "04728a3199ddc2bc9f5c6ba0a1be05cbdf8c1ced5ab3ab96d7597e21c688373e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35e5bdf2d1a98eec330d6693dc4c3c8dc10caaec91dda9724ff81c9112645fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f17ab779f49d8d8893a765f26e3f2d3ebe3d020c85fbd4ad8575165046af0c"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end