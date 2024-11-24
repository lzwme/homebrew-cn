class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.27.tar.gz"
  sha256 "97e98f8c424d6745f7fb1616aa3544ac2b269c17a767831c61f9d62f74641f67"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98a8e283aea75f5b2a1828c98ee51fba83506e533b18e46cf64cb46c49db027f"
    sha256 cellar: :any,                 arm64_sonoma:  "3d0dd47b7e1d2d174145204ccaa00d43e10c9f9e9b753830c63c73406a643147"
    sha256 cellar: :any,                 arm64_ventura: "693debcef03e197d95d2fb6d97aba07aab50c580ba9aabd2e7ce639d26a6cf4b"
    sha256 cellar: :any,                 sonoma:        "8490de98a0e6d17c96cd2879e2067dbd1cfe13043a97648dff1291bcc6d7f0e9"
    sha256 cellar: :any,                 ventura:       "c77d36d1218e56881732874a8487cae9771c92d27292c8d311ac56a44c63f1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff437d400f1d6f56ea4514f2cc288115ee6577eefc0e7bb002f135faf1224b98"
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
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}mise exec -- node -v")

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