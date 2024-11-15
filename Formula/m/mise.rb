class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.13.tar.gz"
  sha256 "1c119ff8cf94a746e77250837b3f929bffcc1f67addf5e3ba5ee218c3a7b0519"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cfc93961ab5c2d18dd4454ea6ffba245f5f1321d440d0e20a1a193d50b5e19e"
    sha256 cellar: :any,                 arm64_sonoma:  "87a979251097e45345a43636b4e2224d7b6b6da6f242d9ad11da74536262be1d"
    sha256 cellar: :any,                 arm64_ventura: "c5780261924b3c63261396194039273bc47e8f4b484dfaa67ba611dfccb99e55"
    sha256 cellar: :any,                 sonoma:        "5d7e2af6d376dad992ec3071687e7b4eddb5c79e5529b50ffcf7bbbf77e267e2"
    sha256 cellar: :any,                 ventura:       "85c1c28f6861d4de9a51d33f01c8b01dc10b3764fbf37e8564bb9b16295eea11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55310623492c863e25cd0f1bec55a97e57e13d654568cf52f7805ce30d5e8de"
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
    system bin"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}mise exec terraform@1.5.7 -- terraform -v")

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