class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.8.tar.gz"
  sha256 "7c6c91b982afb5668c810cf03d44e07347402845b80c6982f0453ae98a9ac46a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66fb73b612940aacceac02ccc11b70a9357310be1f15f771e16b17a687a3f12b"
    sha256 cellar: :any,                 arm64_sonoma:  "df1e005f2395e5b6726eb8430e19efdc6fd6cbda8f6da297da551ecebd4ef51c"
    sha256 cellar: :any,                 arm64_ventura: "a206a3a4688400a887e39bb983d4f0865ccaf2f3f0bb99ac9bc88bd0d5ed474c"
    sha256 cellar: :any,                 sonoma:        "b66096a268da10e3d087f88d151c0e5dcd8f05e3a7affb49a3980ba7d783599a"
    sha256 cellar: :any,                 ventura:       "de12b30a131ff1ffd0afc1e937b64b2a43b6b595337a2b7c16067eb55d544223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048c2c6fb00645534262143e84d7c82f0d348b31550bc0cdbaba5d2d8dd367d5"
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