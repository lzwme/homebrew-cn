class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.1.tar.gz"
  sha256 "0763599841970d9a60630fbd97301d7a06d9ce5c61d9da657fda432f2204cfae"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c97c47a5b662994a592c9111a68568b6c4023401175737befa277e15c242560"
    sha256 cellar: :any,                 arm64_sonoma:  "697ac391d15e9fa8dacd9e214c45aede625a82039a4fe0e97d533ea96a8fd006"
    sha256 cellar: :any,                 arm64_ventura: "3bb476949b2758df84c8424eb793d096fda7742d1e44ce8ab5099930ea93c2ae"
    sha256 cellar: :any,                 sonoma:        "4d735e20edfbbf521a80c68d280e26cf7ee19892062efa2ebb89618a34938faa"
    sha256 cellar: :any,                 ventura:       "ed3d60c40571f4fe2c2c632f04f0291ebf8d9b1f70012181b5ed5d769f6740aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "213981c177fbcde78c856d2e8c187b248b2a182146e59b8c8c821a36befd7740"
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