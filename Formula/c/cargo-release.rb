class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.15.tar.gz"
  sha256 "dee97fbcb6124f7d159cfc0ea8fb3977da1513da2135b179bd48dbcd0abde616"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e617f9b2cbfe43a7c841e82c4e9ace6febaa639666f68b59e176ef7ff48beaf1"
    sha256 cellar: :any,                 arm64_sonoma:  "c77ddbdd498de5f68789072debe9ed69411d0883771db2e9039130ef15bdc57a"
    sha256 cellar: :any,                 arm64_ventura: "bc8e95f349b29d5526778f4024c880c975b5c381962fd719423c89477862742a"
    sha256 cellar: :any,                 sonoma:        "582e6f58dcb8361458e117660b6b4ed6b43126a8e33fff4475200c49da47efdb"
    sha256 cellar: :any,                 ventura:       "3a758f4162c86ec6d51448556dd7b9193fe49aeeaf1f1010a3fee7d58f47174d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f4394fbb5c4647d557163bcab41988b3b0199688e22534b22409249414bb23"
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