class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.0.tar.gz"
  sha256 "d3d9c4bace08f7a232e9e8af7b5faa9edafb4c1877ed2e786acacd52c1c9a2ca"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a97f29fa926e9ca2f458be9cf84df01aed027afbc509e2e73877e10831dfd61"
    sha256 cellar: :any,                 arm64_sonoma:  "ba60651310e2d45ceb977568e947e5da1015212f37f55676d59f1590bce50079"
    sha256 cellar: :any,                 arm64_ventura: "a1488bc356f769338465927540dcd86d8e21e5d60a620648c22625e4fa690792"
    sha256 cellar: :any,                 sonoma:        "b80c887ac4c4cb71268c39ec337a75e77f8960d6e996be21afbcc81cceedd23a"
    sha256 cellar: :any,                 ventura:       "27bcb7b13433c6af8832a1023384600925811de72e31c5bf73370d0722c8cd50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "958b47db11f0491635d5e29eb3209a1e834abdcd6167a14e1ba609d10cabeeb4"
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