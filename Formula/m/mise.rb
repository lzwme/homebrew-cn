class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.14.tar.gz"
  sha256 "c5ab7b875be95d6094a3e42c3800511214fb0ac8065c6b59de9c07e2debf78aa"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e4f93536cc48740dfe8b14184591358a9b5ea3f13c9a32c9a3cacac404bb612"
    sha256 cellar: :any,                 arm64_ventura:  "069bea68da455a68da97e7978c86a321082c57c0b83bc8d5bbdc657e4f32b053"
    sha256 cellar: :any,                 arm64_monterey: "defb030b9cc0567cbe6381a1b4f71443a64f3d7ddbb3ce2fdb3ea644e031bd0f"
    sha256 cellar: :any,                 sonoma:         "d854d3ce001f005d7f41796d47a99e636583391770c4832201b8ae7bc4c272b1"
    sha256 cellar: :any,                 ventura:        "73d89da64840a0c8e5982a318aa7457caf4bf7dec2becbaaff195e775d0b2908"
    sha256 cellar: :any,                 monterey:       "9037c30901e4278f99c77783bb427fd5b3a2693311429e84a5d4d57c0364f670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca19c1dc43b2fafff35529a6bd94cf738ba14b672b39861b4fe6ec0b49eed09"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

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