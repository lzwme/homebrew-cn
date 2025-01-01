class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.24.tar.gz"
  sha256 "82b96daf3df808f0c08af1d9f3b9dee700c3634191f8669a21b9d45905ad566b"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64e95e912ee3213ba796943ecafd47bc1b5495f929632bd390e0df1c2bee906b"
    sha256 cellar: :any,                 arm64_sonoma:  "ea709893751c9d72ba916e94bc4c40bee38e70a4726b4c0b08a23e04bb7c074c"
    sha256 cellar: :any,                 arm64_ventura: "7c09bd6919181e5f97221db0067deff3c3bec769a95b804fda9eefbecb83b4b3"
    sha256 cellar: :any,                 sonoma:        "b83be14583957b98545fedbf4f32fe1fcd6d7468052e8b5a5a262aa6bcffa662"
    sha256 cellar: :any,                 ventura:       "21ceeb07c8f4ff54c174886da35e2415ab7b7775d899ced082965751aedbc310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "243bd930a1933e6a54c6a489df2b99a35a375562dd92b6002b1d33861722d569"
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