class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.11.tar.gz"
  sha256 "806e57856df05a4d70a628b4d6a5e5a08cfe25148aa4d42800042b045067d182"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cb90de97c4fe82aaabf6c435af345d6cbc5400f5f3f3e679c1f37725473b82c"
    sha256 cellar: :any,                 arm64_ventura:  "ef226d68c47d06412bf0e47116baf300f1de4f433b2f0920d1795faf7b2d5e39"
    sha256 cellar: :any,                 arm64_monterey: "f0bfd9926ceddc368d3bb73836c678b6ba01e459579af0fc95f7d00be386c22f"
    sha256 cellar: :any,                 sonoma:         "b5cb604525c7f4e2a6d6b76e7758333559bf0d1f38aa9c977df6bdbaaefec9d5"
    sha256 cellar: :any,                 ventura:        "6de8b69a0a8058769280d9ce7d32049de1906f08a9a82e647a887419818068ea"
    sha256 cellar: :any,                 monterey:       "eb9c9d3eac3074f87761506f002799deb2650657ae43fd0309b7d72eec58d068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "651b323252f1992597fc9bca1d26bda4adebd22e69886b7185fb6646ca4d2cb9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"

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
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end