class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https:github.comjrmoultontmux-sessionizer"
  url "https:github.comjrmoultontmux-sessionizerarchiverefstagsv0.4.2.tar.gz"
  sha256 "0f9369a045ebe181202fcf5f292bbdd836f25b47ca9da1702351a725693631f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a03c3a2bfd283dfb14fe55e4c50fafeea446acf0c228d6979b67a05e2642f0b1"
    sha256 cellar: :any,                 arm64_sonoma:  "3028161e6f942c0b24c1ceb2b1a8d5843b24907cc27ee207f85fe06c9d3bc8e7"
    sha256 cellar: :any,                 arm64_ventura: "7a603d0a09c2c6b64ea010427559a18651a8fe1e5149feca7dfc996c389f2ad5"
    sha256 cellar: :any,                 sonoma:        "903e07fd37d645a9f8d092e9af335b5a0341602d329a4e494f91da9c26f9fe18"
    sha256 cellar: :any,                 ventura:       "34f6b6758df67acd10f91c6d74885d0cc7045a62637bd573e7cc2346af005f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd989d2d8fd9f7cf38648263c92502269c53d2ebdace30ea98017f4da1c2a9d7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "libssh2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}tms config -p devnull")
    assert_match version.to_s, shell_output("#{bin}tms --version")

    [
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end