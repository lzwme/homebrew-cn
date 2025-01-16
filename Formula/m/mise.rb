class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.7.tar.gz"
  sha256 "802fc070fdaf1988abcf6677765ec1a62c464ed308a3741b01395763e2e9013f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c2d63cd864a775b154f1c96cb5146f9294182f81c1d66d18fecf26128603c06"
    sha256 cellar: :any,                 arm64_sonoma:  "c55ed18de7d6a4413251a28cf286ac8c72e64cdd8823a3a69c72c96964074187"
    sha256 cellar: :any,                 arm64_ventura: "10751d7274c473fea539a01b19320c1c82fe910d6b455d469ed06f8bd81d5313"
    sha256 cellar: :any,                 sonoma:        "e14cced90595844111ec5bdbc11c7f06426d009aba6b5a89982a3a87d08ecb6b"
    sha256 cellar: :any,                 ventura:       "498a4c78e2174bd2d2222d7cc5fb7e0a9fc9a05b88df7bd979f8220a9640ca7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79197e4434eb8249636fcbf8cc59e97932ecd5aa05d1121d51f070c41e6150a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end