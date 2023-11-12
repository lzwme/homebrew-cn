class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://ghproxy.com/https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "5fe95e356744fbfb1ab83c049439604e47c9587553a2a0b73ed65c89064fb0c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f99049211034c8b9b9e16251d3d29e37bb4bdb043400aa32a3a2601e6d64aff"
    sha256 cellar: :any,                 arm64_ventura:  "40cd8d546222cba9318445a88cd169c9e517b8ba593e6c0a1252ab4e7fff6047"
    sha256 cellar: :any,                 arm64_monterey: "b2c30eecc6328def4fd2ad1090c4405acc65bbd384c60c137f323a1dbb5bce78"
    sha256 cellar: :any,                 sonoma:         "7a8b4af693e8af340d6daca81ce941c9a1b64df8bec0124ee7992c1322265070"
    sha256 cellar: :any,                 ventura:        "6d0503244572fd4ece411932a93b5c378fd2f174934192dcddbf5b8898b11b6f"
    sha256 cellar: :any,                 monterey:       "d04c4093521726a68843d0052b7373fb1b6699e83f75942c44bd49862bf81542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3e5799d56bd30b8856585ffd706d05d558cc4e677d6cfc17dd1e735b6241a78"
  end

  depends_on "pkg-config" => :build
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
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end