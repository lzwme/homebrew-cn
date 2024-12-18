class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.13.tar.gz"
  sha256 "0b60532a1512dcd28a44655b055cf17236d3c3427e0c8a41683caaade3d1c9e3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be5c90ccef511e80c62493e621c657c435bc90ecc5982952338ee9a7b1c2c602"
    sha256 cellar: :any,                 arm64_sonoma:  "798f3e8ab4e7fc80c3389cb1e4e064dcc117bf6d846ac9f8e5e409bbc6e82cf7"
    sha256 cellar: :any,                 arm64_ventura: "cc01bea6292b70852904787ab35ee88f8cf16a260eed676bdf6abb460419c4b7"
    sha256 cellar: :any,                 sonoma:        "2c45cb63d6ea8bae4e90bb0eee3bbbcbaa3815a05827ac9e960606e8be10bdc1"
    sha256 cellar: :any,                 ventura:       "9063cdb2bc5248bd80c37a06fd4d3d15466204bdfbdefbe5cc4bd082a5c71761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19965e484e5c1ba0496446c053b1368ffdf1c818a40af1a4b0e11d77c25d19e"
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