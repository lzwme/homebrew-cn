class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.36.tar.gz"
  sha256 "6703fa0479104be64ffc33971694ddff7c54d9728011c87e57c07c7a5f96b38c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8203a6b2a06c4248fc8eb3a99b3a89ee0d0399c86ce509c21362dfafd8ea197f"
    sha256 cellar: :any,                 arm64_sonoma:  "a85c59129f792ec79fcd7525bed33f6d761036d1e47c62bee314323bd9d28ed2"
    sha256 cellar: :any,                 arm64_ventura: "c295e07bcf30589eef600efe45a9c60d78c15d18da02e04ae691e7f24ae97757"
    sha256 cellar: :any,                 sonoma:        "918634261c18e3c5943cb0dbeea9396f605f1498e94d26b5570b118e7c91b5aa"
    sha256 cellar: :any,                 ventura:       "74a76e3292c730bad7dfe207057ef89ac2e3941017a0e58b488126f4cf760562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf6821754d2feeb30a6de052aeb8693f9d2507cd7b409b9a94dadeb073050eb"
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