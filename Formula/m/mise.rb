class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.22.tar.gz"
  sha256 "6eef93f758afa65551896b823d2051a0a52fbb02bdfa6c855c175cb6eb1c7366"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e99f4bdb9212240b0035cef281cc5ffd11b868c24667960afffdb9c42bfb7b2"
    sha256 cellar: :any,                 arm64_ventura:  "b565fcdf4e73c0103c24c81c05b123674043a9af20f02a70e2f32d3cf034f792"
    sha256 cellar: :any,                 arm64_monterey: "86c852c2dd38150d6764a164d7410447428a6dfcf80f7d5e9e72f16e0f83059b"
    sha256 cellar: :any,                 sonoma:         "055c1cf35288f1dca7f76b925a3f94f7cbaf7842b061d38d84b990e800f34089"
    sha256 cellar: :any,                 ventura:        "a2df66d3432399057691955fc4d3708e495518fa6b440d29f0e063aabf1bfef1"
    sha256 cellar: :any,                 monterey:       "aa77be5678580e2e0fdd0f4f5d6d9a2a823743c69b5df141a856e18ab305c069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "429313d706cb942fbf1d68d8f9d1fdd913188c6843d70a3c5ae570c91a4360a5"
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