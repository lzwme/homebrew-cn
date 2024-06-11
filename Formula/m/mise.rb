class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.6.3.tar.gz"
  sha256 "b65763e2cbcef12199944d45f65ce8ea974955fd5a5395ca3ca6a2990db389f3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fafa68d8a5e8cb48a23b575f897e83639a37f58f792eaeca6e7b4981e79e3a4"
    sha256 cellar: :any,                 arm64_ventura:  "498bc22fa0acb240c2c88722af0375cc7afe511dc1f2e19324df3d1edd4c7959"
    sha256 cellar: :any,                 arm64_monterey: "09ed92ce504e17e8c7924b6cd91aee05da79b166c37557607a92a486530497fc"
    sha256 cellar: :any,                 sonoma:         "fb9ab74bd492c81bb3720a0fb66fe1223c49c2256479e3a3eced54c0c8e7764c"
    sha256 cellar: :any,                 ventura:        "dd6da055dca5bc6f429d188396c6fdfaa37df05c77fb4e7c980fe9c7a0ee3854"
    sha256 cellar: :any,                 monterey:       "cc8f3a4340ab8aba0ed09d7f8bb14f87285e9eac15f0156f767da013ba8ab7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "215c096ca98d687c6cac20d3f1cfab9c6a262d8040e607f77ee9079efc02a3fe"
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