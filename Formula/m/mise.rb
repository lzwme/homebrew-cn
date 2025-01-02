class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.0.tar.gz"
  sha256 "51e56a831cbedece92b1e3e5eaad92afae9d133503881ad18f229ea41e24a618"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d360f45933d0c1dc69ad7601ef5b9d7f470739f680f6dad512bd2284493db151"
    sha256 cellar: :any,                 arm64_sonoma:  "dd891a2eae30a1e1bbbee3ccf32f039046225c3a349c233ed551f6e1688ee6b5"
    sha256 cellar: :any,                 arm64_ventura: "597a076d9abbf38e40f052b5e396ea2ce175fb4510b30e675e8098659faab2ca"
    sha256 cellar: :any,                 sonoma:        "d5064492a5464bc686bbe39f832f61325882134ab512d6e760648456a7c2559a"
    sha256 cellar: :any,                 ventura:       "520b53db6f291cc3e6b6293954eeaeaa8cd534d907f4f946baf9c7acdf362e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b92e0946bf95be1908a40a59249421a196fb44ab56856e126aca584190232a"
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