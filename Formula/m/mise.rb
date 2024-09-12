class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.2.tar.gz"
  sha256 "50da6464c5f2443edfec82a17d353ba2c8a80ac58c0e3413eb1245b2b70bde76"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91c1b701890c9c9bb677f2ad7824e8a99b875bf5ac39c65d01ffd1663aa8431b"
    sha256 cellar: :any,                 arm64_ventura:  "3db9a59df7df4e31d8e4d179a7af70f9fa473f4386ff4638d6b63096c0d4fd4c"
    sha256 cellar: :any,                 arm64_monterey: "7bc2067a8d1b03f106b90db269e3242df3c862d4c843fe5273f4b527747e32fa"
    sha256 cellar: :any,                 sonoma:         "6ced6942190ab794ff51c372c1896d7747c172ca1d25996c66fe8239d395dbab"
    sha256 cellar: :any,                 ventura:        "f9573a5925e0d2731c214249921651e1d2d6cf7abca27a6dbec33bebae59742d"
    sha256 cellar: :any,                 monterey:       "2bb47d98a64823502f2922f836656f643324f59ddd3121d12bb444062541ae93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6d4a1a7f4a89ccfaef94a4f1e97172a5077848168d5dc8a655974ffecab79a"
  end

  depends_on "pkg-config" => :build
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
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
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
    system bin"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}mise exec terraform@1.5.7 -- terraform -v")

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