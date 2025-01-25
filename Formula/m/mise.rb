class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.14.tar.gz"
  sha256 "6745ef5b1be5478848e1e45d826dc1e37b177efeefc5fedf6fb184ddb7204aac"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "237cd52e9d4a9318447a6f787be7db4a661db0584004aac2352a49fe69125e5c"
    sha256 cellar: :any,                 arm64_sonoma:  "6bbf5772614517063067057456ec11bda6826dae3a25b10009e74867355dfbce"
    sha256 cellar: :any,                 arm64_ventura: "c060cd870e5d2667ed9777406a50623af04d9ef3bff477ae56a8385104ac05e3"
    sha256 cellar: :any,                 sonoma:        "843d29bbaf66b3045fca63c9a68ec7ef5bc5aab44c3760c2d10b6267636f6a28"
    sha256 cellar: :any,                 ventura:       "86e7139ee793ec981d01b7153064fc25bb0d81927508a0ddac13a6fea1e218bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cc39c30a2e893873139558c70bc939d62d607552275c2d686f22aee829c6408"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end