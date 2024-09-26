class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.9.tar.gz"
  sha256 "fc368d904d92b83342032734d6548093973af7b8c5f9035473548cd745bcbff3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e9b1faf6569a37ccf437ff41b33524d3e2e3c4bee3bf4c4bb9299c187459b91"
    sha256 cellar: :any,                 arm64_sonoma:  "03460417079af7305076437f067854e48232fe93f31dc1f4fccbbaed4a2f5d17"
    sha256 cellar: :any,                 arm64_ventura: "8ab5e4286905d2c4bab71352683b81177dab26bbb233f9e4f2321aad68d6e714"
    sha256 cellar: :any,                 sonoma:        "b9e645ac0867f1bddae3372232305245c2f98b7888a24f391f9ccfdb16edb4a0"
    sha256 cellar: :any,                 ventura:       "c036f41ad28e03cc894c570e60fb7bf291ff8f8bf76f75b8b32e53580178886c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e642672d9e5940173bd6d5470711b344a60815384707802c1626fc4cbec3ca7f"
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