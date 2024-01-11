class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https:github.comcrate-cicargo-release"
  url "https:github.comcrate-cicargo-releasearchiverefstagsv0.25.3.tar.gz"
  sha256 "74c2e4c0dfa96aed273cfc38e775663e0f035b29370c43bae0cbbc112dfeb700"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcrate-cicargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "002dbe32aa49732d275ba09aeda3c3e325262273298624a52d1d8f245c607f46"
    sha256 cellar: :any,                 arm64_ventura:  "3cc81b91a31b675805e13cd2d9ffde34a4337e56cf139baf56a5c137e5100d09"
    sha256 cellar: :any,                 arm64_monterey: "3c3607e261e3d965bda811fd4fbc9401be7b96f1daddce72ebcc46013ab1aede"
    sha256 cellar: :any,                 sonoma:         "42b271404f81c07d0a5c0f84e6bf7876bb65bd5860e6651332a7af3a6c4592ef"
    sha256 cellar: :any,                 ventura:        "a14711c8a6ffaa3f6097b6741ffe958422be87a10b45405fcf68b92ae88484ba"
    sha256 cellar: :any,                 monterey:       "40bc3f6faf8b7ada12a1a4af0ce24e8ebf4f1ea0dba7a755d2c717f598e80671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00613b51bf55f69cd7d97ae1a1b8e1ebe9b2802c9f893aca3b57f819e390beb"
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