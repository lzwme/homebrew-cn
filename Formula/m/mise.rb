class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.9.tar.gz"
  sha256 "7c83895c67c62b2736cecaf73aab2035938349d62638b22e5f2f40344a52c1ac"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99fd7b9058e394f00aa49339bdb7e4bf0ce3cb0b793054e8fa76059341dd93fa"
    sha256 cellar: :any,                 arm64_sonoma:  "a73be6e55cda92d16ad7146567a0a47c3c49e6f5c8a81ad9d948b95283416047"
    sha256 cellar: :any,                 arm64_ventura: "349ece7169ddc2c5d82da87e4b88922ab591f240d899ad495172eac49ebf15ca"
    sha256 cellar: :any,                 sonoma:        "9a7bbd7c712760bfabc0e76fd6c568767eac6fb252ab4a2b4c8b2f060335a59b"
    sha256 cellar: :any,                 ventura:       "ddcd2b5d43d1b112cd61ac26143c6e9ac82e5a88ff3a415dd35c8e3d245edee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ec9262ee43e24e828ab8d35ceba510e375dd0f0702051b47edc917b358e23e"
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