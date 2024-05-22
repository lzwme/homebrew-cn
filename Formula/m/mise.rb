class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.20.tar.gz"
  sha256 "5337689fe21ce53ac526d29a45d85e8143eca949ff0a2fbd5a102e0121e7f9b8"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "281ccd3148f20fee0a536f7cbdbc8f4ade795012ba9d24412578dbd3b768c0d9"
    sha256 cellar: :any,                 arm64_ventura:  "ed44a640d596bc53f3671b44c8f9fff59e3f693f7235247158cce35da89c52ae"
    sha256 cellar: :any,                 arm64_monterey: "056b6b7b4509f748f607560a91169e7ebce305801fdce2b2c1a969cf6973feb6"
    sha256 cellar: :any,                 sonoma:         "8bfaef7a276703d84114a131646af476899a8d37fe18f0a38698e934e2938c85"
    sha256 cellar: :any,                 ventura:        "4e44b7b034b27be30f6ce91544bf19ac1bd56a439d3262cecf0a3fada868a48e"
    sha256 cellar: :any,                 monterey:       "f28a795111295d2c374b15997c72ff25cf5b821b263dbe3cbe09cedb98d58c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac9578e5e628b54e14ff48e7f5e9041a49131f6c6d6bf7e4688ea76cd37fd69"
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