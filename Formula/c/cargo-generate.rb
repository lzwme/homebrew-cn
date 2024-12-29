class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.22.1.tar.gz"
  sha256 "f912f1c172a5a51ac7a693f44acaef99f5b9278723aa4daaeb96278807e025bd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4326e76a07be0e6260943e9687a8c7f533cac0354232fd037d185610116b861b"
    sha256 cellar: :any,                 arm64_sonoma:  "b723f39711ec75e2c8bad9de8544a36f6f5f4a56d05edf9c4d3cf99b290a072e"
    sha256 cellar: :any,                 arm64_ventura: "cabf92e8da2ff15436c42334e6383226d08ed64e108492df5314517763ebdd94"
    sha256 cellar: :any,                 sonoma:        "4fc74035244a7a7f9e0b43701554fd1a746f7d464fa17b77b6a76d3a372eda46"
    sha256 cellar: :any,                 ventura:       "6792b5b18b74be10b52a49b9ab60983aa7b70101951463254ad296cdb2c485e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd951667b6714ad976a1563617dba8e572c2fda7bf0a7517a045a2dd630d9626"
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}cargo-generate gen --list-favorites")

    system bin"cargo-generate", "gen", "--git", "https:github.comashleygwilliamswasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath"brewtest", :exist?
    assert_match "brewtest", (testpath"brewtestCargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end