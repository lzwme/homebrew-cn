class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.22.tar.gz"
  sha256 "657d4a6981a2113faf15fd628d0540097b8a618b4253cb0fa50261844e4492d7"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "102a16c64dc3c49042279f06e88c674e0974d6e7d9ebc1fa7213f56562710bcd"
    sha256 cellar: :any,                 arm64_sonoma:  "110b2d5263656928ad382d728fbaa2e829943dbe8184fc71d425744b6422e799"
    sha256 cellar: :any,                 arm64_ventura: "1742151fb9cedc669ddc5814bd711da70a6e94f631172a39dd14450bba97a8c4"
    sha256 cellar: :any,                 sonoma:        "87daf9e6411422a739ac1e763849b74d6f9c96241a4fdefe3741b86d268fad9f"
    sha256 cellar: :any,                 ventura:       "2b09218267a2f89d42cb6eb54a46733bb8c0e74df3020916acac18ad1ec6197c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1796ddd90a3556d3ebf424f472dd5e692d3857c9a6c6b9878b77af45f9db53"
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