class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.8.tar.gz"
  sha256 "44339f0f87203c0bf04b59c7548546a4d9c7f27e4288c84babde97c93b8a57b6"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b8b563790f3c3e4c62afde811cd5c94da860683279830e79370913d0922eb1e"
    sha256 cellar: :any,                 arm64_sonoma:  "dd8d4c1c621ef9878f5aba4beecc810beb8efa15e77cfee5d1457ecafaa07750"
    sha256 cellar: :any,                 arm64_ventura: "d82180c2516986c18ade07baed277af426cbce1b78d988b9dc9c008985fdda15"
    sha256 cellar: :any,                 sonoma:        "57ef0bbb42807a16254d63e228e5bd8bf69421207fd6236398d8715cdc8f29e6"
    sha256 cellar: :any,                 ventura:       "5e9399c58e421557dc2b94f8bd11af3ceef2ee680ff4aed09e7773b39f432dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a588b575b76eae225e7b7ecc39670bdef6be6fdcffb9cf2d6e754abd3c8cadae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end