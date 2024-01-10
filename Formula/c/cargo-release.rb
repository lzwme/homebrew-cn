class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.2.tar.gz"
  sha256 "77756509d7e94d721056b2a35f99bec97665ce24323bfd25d76a39aa04b61dbb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ee66e5f9757bf9a8462a6c437f48ae3234a1a2cffae8b493b7b40e175eb2f82"
    sha256 cellar: :any,                 arm64_ventura:  "7a1545daf05e447421e99382adfd45dbddedd8ae30a29fd2aee20f90855ea923"
    sha256 cellar: :any,                 arm64_monterey: "2e580c962d0eb0dbb6ca6d3493a3246143578fb435c18e5fbc28f4dae0d22103"
    sha256 cellar: :any,                 sonoma:         "4e452761363e05ca5709d2e361df6fa11b34dab3f513ec1fae7be150565a3e5d"
    sha256 cellar: :any,                 ventura:        "d0fb42e44634acb79d03a06f5d6dfad28d24fd24d7efaa38fd4c878d7d58fd21"
    sha256 cellar: :any,                 monterey:       "f74c2da756bf7fee5030639b3a5c793c91d9bc800b64e2e75a4e86f982f687ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e477773d10769f0c79c0543f0a042b46c9a2e985b62d60ac6ae77a766058626"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
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
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

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