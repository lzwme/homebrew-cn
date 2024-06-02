class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.6.0.tar.gz"
  sha256 "9b73fe310be78fdd056aebd25b33c9e8eb85c332304d8f4f9ed46f6cc6331706"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "83451c71af00488fb6e8ed9ac7ff3c9b2c89fe5a218b3683cea159b3989a881c"
    sha256 cellar: :any,                 arm64_ventura:  "daf8c4ecd4c0e5c7eca59bae81e21421243f6f5032770b6d95ffa6011e474839"
    sha256 cellar: :any,                 arm64_monterey: "a430d4062f74c76186fcf1758ad848b78332336cf3eb7554b19ebd1c924cc783"
    sha256 cellar: :any,                 sonoma:         "f41186cf626a793fc07123cfcfc6b8b195011521b780dc98bd8fe3ad5f4f6775"
    sha256 cellar: :any,                 ventura:        "494240b4383582266a480bcfaf166532aeb8b621426248c280cfd48abefb8a09"
    sha256 cellar: :any,                 monterey:       "6118990b97d99c0b92aff00c8d73f1dfa20dd563e139600da8b4462f9434b19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27442decaf65a8bf14043790965340893437375a7d196308ff0f25e0e36db56"
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