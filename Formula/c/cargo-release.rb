class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.4.tar.gz"
  sha256 "0d0e9506863a78eff3a95c882aba98c1d56b3b205a46eccf56f8c3171ae60d44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b49ee1dd0799596e035f391e57f6b3cc6bd92ff7ae87e824561488b82d5f84f"
    sha256 cellar: :any,                 arm64_ventura:  "c6a7ec088ad5fdb047ea73ab99c2cb4bcf0fbd58a141da5344ca9ab0ba16e7cc"
    sha256 cellar: :any,                 arm64_monterey: "0d9bfd192374368f4f52ef711f078588a66e8cbad124520e68fa3815bf660e01"
    sha256 cellar: :any,                 sonoma:         "1237c5325f690f14e2837d15e6168d8b43af86415569c0303dc639434afcc95c"
    sha256 cellar: :any,                 ventura:        "e029050bb4d5184d3e1955976e76e8cb4e36e3c258cbbb71ce155c181207a7fa"
    sha256 cellar: :any,                 monterey:       "3610f458cd3b810883ae3a883312da3d1c09b7462edf016bfa0276f7827a56c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3b7691702ba18c0d795d5c9b96aa77c35697c60ef9628fb5adff86be038fb7"
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