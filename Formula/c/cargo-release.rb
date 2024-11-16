class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.13.tar.gz"
  sha256 "af65e63b3b9de7e55f80c8b465dd88f7c72b0a347922e1a365391459fff4e19d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8f8956bddd623c9b347b9f395444f91c92b5124641626c8d1e55878e8cff05b"
    sha256 cellar: :any,                 arm64_sonoma:  "a235429802da3093c86818832a95b4bd26149456fdca46ef18623c928eee7b74"
    sha256 cellar: :any,                 arm64_ventura: "e8c10c2bb80f5af5d08a7fc38a3b4db6cf8eef8402742ea7954df71e26bbeeb5"
    sha256 cellar: :any,                 sonoma:        "d786da567a62cc7ae70299a373f53103e158c975bf39ec2da9415be12c49df15"
    sha256 cellar: :any,                 ventura:       "7c68f74d2ac6ef7b8e572044463b063d154846782a60d7d416675d627fa35803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1f2ae57104ab9c0d6887e53cd12d84741a2a6a6358016c1dd4833f2e83f77d"
  end

  depends_on "pkg-config" => :build
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