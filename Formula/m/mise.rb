class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.32.tar.gz"
  sha256 "4bbdc18085799cc01ef2d6573056d082309580bad568cffd1a6d4d1bb588a534"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb1a34492adf2a084d5d6890e8152e4c1ebb34dc73fc46bba1434aa4dda77d09"
    sha256 cellar: :any,                 arm64_sonoma:  "ad11776673a5bf8fddc5fe891215cb57ef6bd3b528b0f27809ab101ce38c7a4b"
    sha256 cellar: :any,                 arm64_ventura: "340bb97ca70b46ce8270cbddc6c4fbe92bc058205ecb16ab01b325307cf49c1b"
    sha256 cellar: :any,                 sonoma:        "9698284b0ce2563f794106c364075c7e4c1047113346979247f1848b14f10a93"
    sha256 cellar: :any,                 ventura:       "d267f1b82e163ae894b04915a537f4b6673dda99d46a6c7d0f3fc33b155f1149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730eacdff0670a91997534008209ffc4555bd9e6e0983b0b66af4cda2a09fa64"
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
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}mise exec -- node -v")

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