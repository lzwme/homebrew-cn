class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.1.tar.gz"
  sha256 "82eee2693af7d0ecb59873f8d90defa4a08c641586ccc6baae200e883c467a44"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6a6950c7c876763cc4640e5bc9453d45a175abcbcc8701b2546413b63781ec0"
    sha256 cellar: :any,                 arm64_sonoma:  "60112e358bd854f1668f76e6f5f33887eecdab6053cf43987b4dad15e0db0191"
    sha256 cellar: :any,                 arm64_ventura: "0a100c91f99d0e1a835aac05975e65db8813a0b70dc1f12322d02a9bb75f9072"
    sha256 cellar: :any,                 sonoma:        "55fbfc8ae7a24853d52c094a4fab747819c72c5c2cc7cb8c0fc12804410c1df2"
    sha256 cellar: :any,                 ventura:       "f2a35f351f3860d969802244be6d6a6ad330ba4fd287b6083836c7930759c68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0243af550907dfdca68fdb7918083038d31d04ff2030c22cb731a743596ba1"
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