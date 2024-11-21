class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.19.tar.gz"
  sha256 "cfffb1d58f132e40c9836877afd2da3e613a6342831c02a1cbda57115ae2004e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b16048a9a35b42a2300081beecd05a34f39f06c0dbaa49aada11a258af21bc5"
    sha256 cellar: :any,                 arm64_sonoma:  "86f62f85f14efc3539400d98eeebedad0383dd9c5e3d63110c4bfc55fe6515e3"
    sha256 cellar: :any,                 arm64_ventura: "c3bea256d2c990bda5a68a96c9afdcf689faa5c6fb9290615813954a38e8a3fb"
    sha256 cellar: :any,                 sonoma:        "395d9d558ab3a4d0082b6998c2359df57be39aa1c1f1f00bc94524d1bae31145"
    sha256 cellar: :any,                 ventura:       "b1c6f738757e23d0838c7b79bdee65db843982bc211404254c7c5f551cf9b9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c157ff80373df2bb8ef04cd67dc03f4aee881b6c9a18445788159906a1aeabf0"
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