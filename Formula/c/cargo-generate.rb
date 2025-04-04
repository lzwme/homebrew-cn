class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.23.1.tar.gz"
  sha256 "b5408fcd96cb1cfe26625684c677169a299035cae2f73fa00ba09b411c4478c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c285222b39165442358f8b6de37a408c4f3a2f78f7b84487a44fb4c541d14da"
    sha256 cellar: :any,                 arm64_sonoma:  "c3e7eb2d89ec5e51bf8f464339c821ae9b0890576733751d88fafc2957dc1413"
    sha256 cellar: :any,                 arm64_ventura: "82a70c10603107b744b15821afd91304cd769e35ada16e3f457331982c214566"
    sha256 cellar: :any,                 sonoma:        "06a283f02e86b0c7dec70577ec84ad2274e2aa41eb79605623e2727b68bfaae2"
    sha256 cellar: :any,                 ventura:       "22b5e1930846082d966b7796feeb3f5699504a43340140a9999f5d9545e8349d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8a4e5ac66b9c2494b450658688fea0766936744e3660ad7cc3a2dfbd7403ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2f80905ff921f181e2be031576fa160bc865b8f901d1ea3748833dfb8a054d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utilslinkage"

    assert_match "No favorites defined", shell_output("#{bin}cargo-generate gen --list-favorites")

    system bin"cargo-generate", "gen", "--git", "https:github.comashleygwilliamswasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath"brewtest"
    assert_match "brewtest", (testpath"brewtestCargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end