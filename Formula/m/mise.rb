class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.2.tar.gz"
  sha256 "fe9d0dbf96574e3c41ba50e78b6e35b5a1b8f4078d234d2c2a13cc74b5e980da"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "556cb0b77a5e761f0d24ab154aeae5a4b9ea88572db81ad5ef1d66db8e9a9389"
    sha256 cellar: :any,                 arm64_sonoma:  "18add74c51928ad79152067c7035ab324b2e6475357241f3651217257e943018"
    sha256 cellar: :any,                 arm64_ventura: "5706a0a9c4f98203a5eaf250481b398976dd1786bb457650444ac018ef1ef59d"
    sha256 cellar: :any,                 sonoma:        "bd3b1a56344652fb982bed50f70307e574a9097e9b07890fd8d8cf1126d170ed"
    sha256 cellar: :any,                 ventura:       "2d71fe4b7726be5614f3a658590bdbc8828f2190ee02a74eaf7893a316d73916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0bb36d95ab28ef791e65580778f3f9f15be7cdeb98148077f0142b210e09a8"
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