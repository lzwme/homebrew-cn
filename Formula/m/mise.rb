class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.21.tar.gz"
  sha256 "7a708ccf3bb2cc05e1ab35b170e33c3f9761d8d48488c11de93e10525e95083f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54a98b1ad2218fb22bab7847c0fe5a1d3daaca38f0bb05131de5b8bdea37e4a3"
    sha256 cellar: :any,                 arm64_ventura:  "cc203623c77f9ba9483979b357f7c22233f68deb5cc8562c7499cb63e4e7eda1"
    sha256 cellar: :any,                 arm64_monterey: "644f6a35f68b612767a57960232b3f9f32b598d2b2a6c1f9d0d38f5c6155a4d0"
    sha256 cellar: :any,                 sonoma:         "95f97b4165d5ef095659321d854742570082f19c3ee0ded9caeb6ab78296f164"
    sha256 cellar: :any,                 ventura:        "843649478e208015a0e5d83a8837d5908206bef714b1d757df0d364a6e648a39"
    sha256 cellar: :any,                 monterey:       "efa8a5bd611acb42735217d963767c43ed7714aefe9d272b868d56f4b125584f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c353fd705eb0a9586aeae4c31bf4ddf3b52d3c676503c10c8cccc4d07c0f77e1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

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
    system "#{bin}mise", "install", "nodejs@22.1.0"
    assert_match "v22.1.0", shell_output("#{bin}mise exec nodejs@22.1.0 -- node -v")

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