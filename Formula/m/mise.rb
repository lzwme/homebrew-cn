class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.5.tar.gz"
  sha256 "0b7b2bb056bc9429d585c8c23202b1c299793e9b7b72017e3f7b5df390b25ad8"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "374730306dc4514d838a04ddef71087da24437210fc64781053f576105b5d8bf"
    sha256 cellar: :any,                 arm64_sonoma:  "949d982e11b748b3ddef024eb7fd8049cfa6127577536101d61c460e39445de7"
    sha256 cellar: :any,                 arm64_ventura: "99940fa62a7dcfcc21e3c529748fd90d4c31bedc005bc92f3513ed06e4e4546a"
    sha256 cellar: :any,                 sonoma:        "a62bcaff3a871086b2830511756755f2eb05225f7e563619d7b2bb69ea6a508e"
    sha256 cellar: :any,                 ventura:       "70706b1a8028b14aadbe2255f3de084ad270c5af114c975237854258b26e24e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec5ba776fd67eac34ac0fcfb1c331c353578c4bea12330b9e4b6d056e5797234"
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