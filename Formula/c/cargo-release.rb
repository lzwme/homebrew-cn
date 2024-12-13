class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.14.tar.gz"
  sha256 "a53841db3ecff6eb9e290fab13ce2c782eaddc59e2783b730e46b0bd944378c8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48f1bdc0d51ffdfc33f2805e2ad45a97cab4b11dc59ff90de95cf66797aa91f4"
    sha256 cellar: :any,                 arm64_sonoma:  "e7cc9ae4a69330137281390bce8760a0282fa536cebdb8d910988cff7c95781e"
    sha256 cellar: :any,                 arm64_ventura: "2bf15ee52f15502b26da64d1c238c9f6f177d9e415c0a3be6d4af806ba21e3e9"
    sha256 cellar: :any,                 sonoma:        "546317c62256b673ff1e84ca654de5744a6a7a35741cb373cf43edbe62ea35f4"
    sha256 cellar: :any,                 ventura:       "b70299068fa7e9dfe1376a63c369b15ddda21b05432214c484e6ce7f3a5caa2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd5a21d3258a17db345b7c2807a5328cf41d4dc143d2b4bfd10d53c2ef1c29b"
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

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end