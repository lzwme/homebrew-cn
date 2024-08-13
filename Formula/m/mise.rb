class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.6.tar.gz"
  sha256 "890a461c56f151ee997513fd024e86bfd15469a1949a480a64348d8fdf4116b1"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44c447e4963ebd64ae515a78ee4b2f0ad6aaac68416119e310f592a7f3da79b3"
    sha256 cellar: :any,                 arm64_ventura:  "46c38785c566babaa0e70ad54ce45ab5bf5fd41a163e9191422646431876e48e"
    sha256 cellar: :any,                 arm64_monterey: "dc2b29b2ab5cfd9abd5b2319f5e647dec277ecabb00fad162018e0d925d9d459"
    sha256 cellar: :any,                 sonoma:         "5d7ae0dd1086f6fa633e7c703d8f5f284b856253d8f0874b95d26ab1fc887e19"
    sha256 cellar: :any,                 ventura:        "3613116690176a6806558f533dc13c924dfd2a0f69b3319b7670765214aa8333"
    sha256 cellar: :any,                 monterey:       "103ad44e71d8083eff2dbbbac7399884c5e1ed6eb647f624fa3a1af3aee1bab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746a31180528f9d415d8129d9cff6ef01df78efa01fb51fdcfaf0c9bc0f79d6f"
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