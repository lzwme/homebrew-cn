class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.15.tar.gz"
  sha256 "2c4f0268abcb56ee15b7ef11cefdba1d8f481214dd89821fbbd83b82f0c5822a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d35bab8ba782e3b23a6d14418fdfa8485bd3b7efdb581caf9043c39d4a9acf2"
    sha256 cellar: :any,                 arm64_ventura:  "19f8bc358af699408599fec96a9c72f499242a75d28f772384f35fa8b3043aee"
    sha256 cellar: :any,                 arm64_monterey: "23dbddf3602da8f12034d69c97fe4fac162861509690b3d452a10e4b8bfdecad"
    sha256 cellar: :any,                 sonoma:         "588b7c84bda312200457aac852ef5680fcd8a243cecea6acea366e069ccce7e4"
    sha256 cellar: :any,                 ventura:        "fe84725437229df659f9e1cdc1c8b660d9e3ef86168cad55bfb80fec54806e4a"
    sha256 cellar: :any,                 monterey:       "ca49bdc1d0becf5c72ffa2794d13204c06ce06f253b759ef6e77e9df274afb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a369814af1dccb7394bb92c3465cb6373d0f11364a7d324339046268df237e1"
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