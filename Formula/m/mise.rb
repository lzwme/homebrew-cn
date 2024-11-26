class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.29.tar.gz"
  sha256 "60a986d896e2cadd036bacc5badb7a50c4c1311a440c6c9190303ffef651c161"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14578036c2d2e7e94dfd84316601c85b578be02a3843eecc23aa3c960717742f"
    sha256 cellar: :any,                 arm64_sonoma:  "7b6ba5df4202114d6a3afe02564fc7229ffee36b32328557c42e4a3d473c636b"
    sha256 cellar: :any,                 arm64_ventura: "2fbaaeb6bb5a9032291a33bab027d29507480d6881b311a1368974b07515f5db"
    sha256 cellar: :any,                 sonoma:        "d48384133073feb2c7698ec1ad3937a90fe2bf7f3c15167b4125551b0afc1341"
    sha256 cellar: :any,                 ventura:       "c8aad04e8ed3186c195f60f8703910112baad48e1cd86ba901b7f9bdd4567f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29bc8b3e2cfa5478078f2ce25a027254c77bff560b23c7a2308f7f6d5652517"
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