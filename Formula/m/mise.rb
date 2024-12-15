class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.10.tar.gz"
  sha256 "f724379119f69b056aafec6eda5faf58db1d11c9ae333cdbcdbd4e7c556a965c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5357fcf59611b4ce0541c4be9c829d3b97a0f5b11e1ba039f8c9f4f7d3149b28"
    sha256 cellar: :any,                 arm64_sonoma:  "3bca2dd2abaff1ef064e93d2281acc2f0370969145f5467d274c88aa29de1c81"
    sha256 cellar: :any,                 arm64_ventura: "ec5a8e92adc6a416a85d2f535331d480a77abf99ab7d5fe6b0b0b257160328be"
    sha256 cellar: :any,                 sonoma:        "38b92410501f5dae05f99b80e111f5d4703ad4d622d65ca0993d890efbd00565"
    sha256 cellar: :any,                 ventura:       "54f0c8ffd781d53e434b7ce951720f711f138afb7b4afb2041a7d9a65f76e1ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65aeb09e1ffbeda33fdfa6d190e0c1b95f9a42d2c0c576208c2082f206822ea7"
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