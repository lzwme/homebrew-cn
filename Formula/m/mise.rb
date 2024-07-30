class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.7.5.tar.gz"
  sha256 "a6e7ec93726cea0a56be3e2ec1f728611d4ad7e4d2348f705914dfddf9e7fb78"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d420ff645c77e2d82e85f10aaa7806a43441f495e4a45aa78679abaffa9da38"
    sha256 cellar: :any,                 arm64_ventura:  "fffbb096446f6e9eff7b7ba8d4d166e6aeb5597f168ed986947c712c759fc5d8"
    sha256 cellar: :any,                 arm64_monterey: "273559bb514f3edf8990f8a8222b99b5240096b9eaac799995427c2fa2117e1a"
    sha256 cellar: :any,                 sonoma:         "4b2b28f3b16630d0e13d93453d620c493f4263d6bc861dbf12457887d5755608"
    sha256 cellar: :any,                 ventura:        "5103b864b1f8f81ded553ce7394458ffbd16bbf14d939d2d4b5e0445d59b1e7d"
    sha256 cellar: :any,                 monterey:       "982098f5c3ac98687008b4fa6c163d8d1b14c83060adf70dd700800aa55117cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb35099d98139682c4bb08c69f748d22b12d0ad93c48082771d893b24d0e83a5"
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
    system "#{bin}mise", "install", "terraform@1.5.7"
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