class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.20.tar.gz"
  sha256 "3bda8fd6115e9513d7b69221ca699ee5a80fafa4b80ea48629967ada8d56352a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce16ad9d1a5cc587369ee8a7acd744bd50d6422a82d9cebaae34a39532b5e50b"
    sha256 cellar: :any,                 arm64_sonoma:  "177f60c55b4d0fcbbbc48be9f23c5d1823041426bca99832eea8d0a16be8a897"
    sha256 cellar: :any,                 arm64_ventura: "63100096ce3eaf32df698a40d5f2fc5ad31b6ec1e364f3c656dec3bc5cd6dbe0"
    sha256 cellar: :any,                 sonoma:        "070aa764035d95e08ee63266ec43d1bd3f2b4ae2527787eaa485b78c6ef6dd11"
    sha256 cellar: :any,                 ventura:       "7def9f3132896047efb694dae80708ce10a632d70a16cd80b37845eb4e55bc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f22acab84c35c2207db98828c56b995203af7be9a3159672201497e3512542"
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