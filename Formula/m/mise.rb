class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.4.tar.gz"
  sha256 "530730e4e55b13731adc67791d833a74a491a18412500b5279b6a8835ba1fb75"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "500939059d35a03e9b2de0c47a99cdfac55bb2032ee2fea7255cc601ff6fac40"
    sha256 cellar: :any,                 arm64_ventura:  "345d30da3a8a375bb83a6d28137827ded8f1381a450df29d6365545837782d35"
    sha256 cellar: :any,                 arm64_monterey: "f9485a1de7712cc3033eb75644b94ed3dcde3afe718f07e559905c09ce1348ed"
    sha256 cellar: :any,                 sonoma:         "96fcd25320d00e5cdb2673293c96c5f4eafcee02c603afa85cb2bf911da4ade3"
    sha256 cellar: :any,                 ventura:        "7ae4f1e1c88c3edc545ec831fdb48fb38f34032c3fa58fb61219124187752cd7"
    sha256 cellar: :any,                 monterey:       "531b46fab41f09932a67a90163c4e2011da075a06031fcb79c68e9714fb5d780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e8867681b67797133c018951ef56e508e146b616d6c8512b66c942e4f2ff7a"
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
    system bin"mise", "install", "terraform@1.5.7"
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