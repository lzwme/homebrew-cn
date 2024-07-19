class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.7.4.tar.gz"
  sha256 "96684077b01178bf402873f130a040e0ad142c729e95184b9d176e3e9092299d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00dc0c6fab417f8ddafb7031481b91922884dc7227d1d323e39ca3fae9329db0"
    sha256 cellar: :any,                 arm64_ventura:  "bc88d93b5014d713faf99d241ccbdb8744005f9a8de7d9fb198720a304d850d5"
    sha256 cellar: :any,                 arm64_monterey: "d6fa683497247606bbdd3cfbdf3284bbcd96bb44ff0b41eff70b459edff086e1"
    sha256 cellar: :any,                 sonoma:         "addb058a61fb9323506488a54962bf84b9ec4405f5bb77eaa11fa5292eb35b6b"
    sha256 cellar: :any,                 ventura:        "765919c56fbb5499920877bb3be17953116acca611e797e73c72b7633c65a2b8"
    sha256 cellar: :any,                 monterey:       "4709c4d8188b6e0c4e590e760e37d60fe9e62cbd444b593bb904fe10790b7864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c239f0399990f36ada1fbe187fdfc60de5995bfcd1169f0be197524f4fcd3463"
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
    system "#{bin}mise", "install", "terraform@1.5.7"
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