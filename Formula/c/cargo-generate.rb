class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.23.0.tar.gz"
  sha256 "01b285b8bcefd0500444ba57c079ee955bc7d3417eb16143c1cd0e4fa35fecd1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24adf82c641e081d2ad171202b256f1abfe0ae09431b64d78aa70d0d2f415b89"
    sha256 cellar: :any,                 arm64_sonoma:  "35acc663d2fe2e3d05924de84b761403aadaab56c5c6ef51b095d192bfb1f7ef"
    sha256 cellar: :any,                 arm64_ventura: "4ea3b9cc702ae6012647d2d172659c3758c8f887c127154dc58f0053e8b6bcdb"
    sha256 cellar: :any,                 sonoma:        "759edb91aca8300ce9662a44db1839b7f58b7b4c4bb9bb86b5d2e50faff27609"
    sha256 cellar: :any,                 ventura:       "e1eae7692e3eef6940cee03d746e9c41d9cc44099224f4423a104eb5ba99f597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a16d4b3ec6742832d7ab9384cb06b5876b61cee9e8e8ee3e479f224499c07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36c0deb64b259652f5fed534a5c597e103c928294ec95eef1af309919043719a"
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