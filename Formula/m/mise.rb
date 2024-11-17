class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.15.tar.gz"
  sha256 "e22cc8cfc7cb0c1ca489ef82df8c7292f78b4bc82fe13e11631e06ebb85cd4cc"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e223daf516201066314e05be2ec5e79fae114744ccb42df1d0445cc17a073e9"
    sha256 cellar: :any,                 arm64_sonoma:  "49de98c8af73583193eab56dc78a1aad4b41e3ad76367bfe9de6205645b9dfff"
    sha256 cellar: :any,                 arm64_ventura: "7b052fe895016faae79c28b476b3868a77df181a27305ac3eba908d37384c789"
    sha256 cellar: :any,                 sonoma:        "03bddeaefc3b229adb263b4908639d92de373c7f82dfac9e4841ef4c196c95ac"
    sha256 cellar: :any,                 ventura:       "35bfefcd46716650526abc514013103de9da298a9d20a9163c82075a4e369c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8242ac413d51995f19983572cc25bcf9b438a94c584010392e21188cf009d7d4"
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