class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.17.tar.gz"
  sha256 "ca11c3cfde607a47a632fd05dced9c80db817311b398409bc1485c64c3053255"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "058d393c1213e99d1f6e77af4e1f1e519ca66d96a6f2f9633a4d39cd4a477832"
    sha256 cellar: :any,                 arm64_ventura:  "d12d1f76d96df3505f2d9ada53b0539d95d84c33f88bbb18de9821611532f995"
    sha256 cellar: :any,                 arm64_monterey: "ea0c11560f45fe8a711d814b9e0b7fd85020fa1b2100651b20757b28718934fd"
    sha256 cellar: :any,                 sonoma:         "765a2a03b44c11298ed2085d1237e2f26977475ee6571f84089b2e0c491affbf"
    sha256 cellar: :any,                 ventura:        "fe3cec304b8d653f7ba5be152dcd7c858664199a557c52948f718334373a6b8f"
    sha256 cellar: :any,                 monterey:       "6a452325e6fae96e8a0083deb11539da00198a50037695a426d971297804554f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c7719c05e7600618e0c85ea603eee03cabe5f73c2fd1692396d65fbe80f599b"
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