class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.3.tar.gz"
  sha256 "954b3f017a958d9c55843a4deb529d87b7afa3cf8f639b1246e42697c617d85d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbad980aef98a67b923a231cbd619b3ef31b01af529158b3ed280c3800eb869a"
    sha256 cellar: :any,                 arm64_sonoma:  "74a46ea31ea4a4577c5ee4d5093cd693f8dea59a2d7de719578aabea3d5f8771"
    sha256 cellar: :any,                 arm64_ventura: "1e4001dada7b8ec432bafad58e3123b9dfbbee9f656710546bdb1c7dac5b795a"
    sha256 cellar: :any,                 sonoma:        "6310edd591091a7545c0194a03872b0a5606769ecc30910b8394be6a95510797"
    sha256 cellar: :any,                 ventura:       "292e5cae6c08f5b454086e974e8a2ebf00f46e6fe81ae54d9360c8dab2a491d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7adb1926df23c08acb2c2b8e29c1988beafd25b6180f5e85b4ee8dd11ed51952"
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