class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.12.tar.gz"
  sha256 "0eeab8fbf1b25517d050776be89de35826ced39311596c8a09abec6d89fa1f4f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15b32d14324233b95007fb0a5be9a6f600d5897072b8128f4f7c48eb59f409eb"
    sha256 cellar: :any,                 arm64_sonoma:  "225a538d24db92db1026c25872b15154068bb6c3883e7adf5e5430adb4ad0ac6"
    sha256 cellar: :any,                 arm64_ventura: "324a1dd486d1e72aaec15ae2c7a14872fbb31f729903231e31591f955066bb7f"
    sha256 cellar: :any,                 sonoma:        "e62b22c8dfa76182b56ccff4871e5b7a0b85c08a874c38bd231d3c7016eaee46"
    sha256 cellar: :any,                 ventura:       "2d4f47f1d2d6f007e094ac92bb84b67792100b8cc670eb82f9030cadaf809055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2179442ff331cc9250c2de6722c43a3e7e9658759023ec8b914362613965792d"
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