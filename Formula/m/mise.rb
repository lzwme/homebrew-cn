class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.11.tar.gz"
  sha256 "059ae28e362993ea18df9edc0434c9bbda6abf3bab81b61447c462199acee63a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bee37c8a26ebe28bb166ffe405c5ff27450d47a443289e257a1fd0642086031"
    sha256 cellar: :any,                 arm64_sonoma:  "41ea51e33c6731e4f70a084a52735e30c5573242f83beef80bf84289f8d49ac8"
    sha256 cellar: :any,                 arm64_ventura: "4656e3ec9a8642ab0110697ec1719e659aba26c10f9baeb054f047741e64e773"
    sha256 cellar: :any,                 sonoma:        "f2e81835ea85e8d891d8f5b8fc7cb247ea70ffae5221680d11414bae2d01209f"
    sha256 cellar: :any,                 ventura:       "d660e4755918a2965833084623947d4eb8edd20c6a3403ab1681bf547f0c4ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc26e96d9dcc872910d0db63002605f84511cdbdc511008fe35b1295e443ddb3"
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