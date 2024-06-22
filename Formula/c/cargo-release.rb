class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.10.tar.gz"
  sha256 "3db220c865caa9820bf2d66c0c5a5ad5a3c7be7ec91c27c623c0f62c3754ea8b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "170ba4c7a1582330c4d7e77149768500c8fe118bff1f910ff1766f81d3cc4732"
    sha256 cellar: :any,                 arm64_ventura:  "9a0f1a1c3f607ae0f328cc66453727bae0eda76a4ab4536582d95214a7483baf"
    sha256 cellar: :any,                 arm64_monterey: "774d9b485fe2b113ad1eb55c8a0bb4602c27209723701f770f73ed005b38ab54"
    sha256 cellar: :any,                 sonoma:         "4f8509af2c64d0dffd51c3c83fa88c98a786dd300bef5be88e0b36c0868d549c"
    sha256 cellar: :any,                 ventura:        "30f0e1c923b216a8f389f5947c4e4d8b54279a81183b365e8643646c3a72be77"
    sha256 cellar: :any,                 monterey:       "729bf0033e689db14a89729cdb758b5939ef7f9f39da6f22c175cc7e7d8e0808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b509848411074860c70a02c1562caa243735c25e12b23cb62d0094db74cdf358"
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