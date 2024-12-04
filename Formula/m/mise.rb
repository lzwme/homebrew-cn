class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.37.tar.gz"
  sha256 "fded755551f9cd31ad9ea1287ff395b2d0700436ee35cf4240a3447c74647214"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "073efd42f615f276d1f73cb0e3dc0027540adcd67ecf6ffea7875f9dd30a15df"
    sha256 cellar: :any,                 arm64_sonoma:  "ea1343374abfb2c7af4a362b79da83f24dcaa5081092f6897f8c3bb14d41be37"
    sha256 cellar: :any,                 arm64_ventura: "2ffe51f935664e2ff54155ebb9ab2deaa96c1fd168bcca06e1eb200be8e0e1b3"
    sha256 cellar: :any,                 sonoma:        "d44d8e5faf36463ad340e1784a21b0d277fd736359e05318dca44856a1d2b79a"
    sha256 cellar: :any,                 ventura:       "2a51bad3ef17cdd2abfb76cd865f42f8524b84fb8326923a3572eaa6128e704d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd71368c7f57f3bc269090cbcff48ff4836e9cf0223ba25955b1b3a8d2992e9e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end