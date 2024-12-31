class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.23.tar.gz"
  sha256 "0e28e3e4b3706a9ade2d3b701bc048a0cff67708a8b69f04b2fd3410e725cdcd"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb0918de22bac1fa7f3bd00df17454799fcc037e906c5f096acef1af3f98ead0"
    sha256 cellar: :any,                 arm64_sonoma:  "53fd953be03107933bdbacb1db3e8f1001176bae33cb6ba6abb46d2da71d02a9"
    sha256 cellar: :any,                 arm64_ventura: "697951ae281acd0bdce1e4ee158040e06235919d45a028f847c07744e408e61a"
    sha256 cellar: :any,                 sonoma:        "8853da70c11e3fc90d7121adfbff034be1d4c367da356c14506331a10913a50d"
    sha256 cellar: :any,                 ventura:       "66d303d39ab186964ad7bb627561b53917b74a480f5ba0c1127e73599998f8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a2186a6837bfee933334a11f7e50b9254728a8baf4dfe1af0827f19cb8463a5"
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