class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.21.tar.gz"
  sha256 "46fa120107d240fed0b0c05c91a32b2f00469e656a9a0b53c4593bebee5b3247"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24c1cbcbe20da7f937362a032c7a8428924870e95c421495e5e0b214ce5f0990"
    sha256 cellar: :any,                 arm64_sonoma:  "bde299662578b8c389c852149cd9eee19c029328d61b4ef1e9fda86b1673a5d1"
    sha256 cellar: :any,                 arm64_ventura: "a7434d087e3814d1f3c4fbeb7a88f4de265493d58ecf5735863da5e6d525a498"
    sha256 cellar: :any,                 sonoma:        "fdaae2dc26709164eb4a5320a239c75bfa5a09d787d19b37a1e4cb31abce73a6"
    sha256 cellar: :any,                 ventura:       "ca8c668ff80de036b2acd9ce8ecb2fd5d5911ceefe157759493a2cd085af1f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eff2bfb8e40e399b7b059c56af07f825e7235ae63498e046507065ceda792cc"
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