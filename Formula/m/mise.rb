class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.2.tar.gz"
  sha256 "81ab3596bc6b334fc76cb6ecfafb8178a4fa8a2385b173ba8df6b06a92d2d16c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbc9acf1d7c67b144a0f9519813f29ed08f199c5af7d28a41f5e2eaf850faf60"
    sha256 cellar: :any,                 arm64_sonoma:  "cddda9689c6095d18fe5c801d6b7448a125fc7152be341e32175072652b13910"
    sha256 cellar: :any,                 arm64_ventura: "91b973db84660c2cf07904b8b739a0ef55d987f4e3a6cab4e0e4ddd898872089"
    sha256 cellar: :any,                 sonoma:        "0de47bd2ff57729e4c9dcad361e1545a9e4293154b4cd7b897f46711b32d43c5"
    sha256 cellar: :any,                 ventura:       "b7762230b2fc35a184a36fc0b1e1482c1586ef8314b37c531b7d6684f487b209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff76e1d22a10ac60379f5754dbbe91156ee8e975a979ae321ff79cb8d6248cc8"
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