class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.12.tar.gz"
  sha256 "2382d581c25dfe4363ca2ed2f5912055ca6e59a03dba0a5689e14dec3aab602c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa4315227f68938fdba85a438fd9cd6ce7fb081aa66b3b9f3d3e9775deafb20f"
    sha256 cellar: :any,                 arm64_sonoma:  "84a4757504905da942c2cc804d4fe4452a702c2c8331dcb204ece9cb83250d70"
    sha256 cellar: :any,                 arm64_ventura: "e4d9c64194ba19bd580b47d1675e8e30b20881a285ef7d8195f0441f39e09487"
    sha256 cellar: :any,                 sonoma:        "30bc792d483250f7d7d9c62d2cb48a5972290bbc2af4ec262aa191003198d64f"
    sha256 cellar: :any,                 ventura:       "5a59dee2fc485dea263cf1aab7bff3c8f1634e49b82bc9e6107c91e33a98a290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874eb4dbd1a633438b2634bcf99f1d43f74a52b09f10fa45301e60722c5c0a56"
  end

  depends_on "pkg-config" => :build
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