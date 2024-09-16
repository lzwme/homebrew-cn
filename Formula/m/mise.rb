class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.4.tar.gz"
  sha256 "a45b06c17e29e4dc3669adff215eb232460ee5644866dc16d1b2055bd5ddb169"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9ccbe4328104a08dc355c3cd5ae2cd280ed30ede42dd583296673e25f599d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "5fcc2b5ed80319b02159ce18f759dcb466d9824b72811124daba71478b762285"
    sha256 cellar: :any,                 arm64_ventura: "2c13701f4e6909b141cdebf792462d35242cbbcaf40f3be1978335e16bc759f0"
    sha256 cellar: :any,                 sonoma:        "d0f3924e75e79dd0bd12da031053b0bd8f7f909d344511b7de6ae1465239b9ab"
    sha256 cellar: :any,                 ventura:       "7fc8950cd987f8cd7a36284ea036d90c9bc811b5fe2e98799bac3254884049d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652e0484c14589fadcdd2be12e0bb8faeba3a75184ab50da93eb71a85597740b"
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