class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.21.1.tar.gz"
  sha256 "3159eb16de57e0b28af67fcda01bcd54eee81edfbfd882e557018e4bcf6f41b0"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "270200246924bf03d6b65f045470cb02d350793f74af8840c910f03c60384648"
    sha256 cellar: :any,                 arm64_ventura:  "240f31a914b5e34f5dfea0b2a41e65d5e75f72235eb2fe39a0c41a44d5dd6eb9"
    sha256 cellar: :any,                 arm64_monterey: "2975d50089c42f93d395bcef7d87d3086aa9de43819fba4702a7438d7db4c5ee"
    sha256 cellar: :any,                 sonoma:         "af39c2d6ab64b86a47719c8a33082d2fe8fd0ebd410da5638e77a8d4aeb7d0f0"
    sha256 cellar: :any,                 ventura:        "bbe1c6f32cfd4a3cb227a18800362b0a988bd8fa2cabb674aeed7369d7dfefe8"
    sha256 cellar: :any,                 monterey:       "a0132ed5b82c040c7ab5436ba03a856b3c856c9c87e1b2b7753f542cf36901ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e598308f4ba8a8b36741bc57989e663e2eb88b54c098c78e478a6776eceb138"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
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
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
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