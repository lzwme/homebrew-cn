class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.6.1.tar.gz"
  sha256 "0d4aabfb878865cec0410d8c10dc241b5943f5c4e87b0ab2446434726c3d0900"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26f8a5b3847c57dda6a360e3108a6cdbb30e18ca7790e734bae877346efc1a7f"
    sha256 cellar: :any,                 arm64_ventura:  "f104cb89458491dee07819875e2eee67047d7ffe3f5877946aa6e422152a8bab"
    sha256 cellar: :any,                 arm64_monterey: "cc5abf2c8bba1fa7a2c65ebdb630dc86eef9a81b475405055b4e37925bd98fdb"
    sha256 cellar: :any,                 sonoma:         "a6ece7a8a93dc4371d8156002975f71d2c0aeb00d7e26c2c7cfec1d6bebf038c"
    sha256 cellar: :any,                 ventura:        "e6fa733badd58b5ed2981a920647c98e22eb468e2700c784828a723702ef7cf7"
    sha256 cellar: :any,                 monterey:       "8188370fe8e27bcd75daa1f5bd679006f73155ed2a6941ea3d930910e4122b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9607f2edb4b93bf02d0830d7d2dcd1086051d7a0813522d367653c0592f5c9"
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