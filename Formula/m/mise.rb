class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.6.tar.gz"
  sha256 "6ab71f407b050325352b76b007274134e6fc4a1a677d1a7d46c72b3ced46951b"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e7f0d5e60da9ac54a51b9859b50df4683c6ce237d388a4bc23c082064619e93"
    sha256 cellar: :any,                 arm64_sonoma:  "2ca775783c2c8f1836d2ccad441a13e36218c09b3a5c190d0ff06c807f58b940"
    sha256 cellar: :any,                 arm64_ventura: "3033fe8a3821e8e503b19526ca387bbb9f1553541e17475a97f67041ddc29ee3"
    sha256 cellar: :any,                 sonoma:        "a968ed8cac9ec5eaaf4f61fde43bc62b8a7039c676f0e9c7a7e63640e7d39d68"
    sha256 cellar: :any,                 ventura:       "1f7542d98a417e1dab44de1e2942f88104db82a718e8e81f361941599ba83dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9316394e48be59706478c0d8d865d0c970096ad2959cd5e52fcd761a67382b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end