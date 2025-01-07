class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.1.tar.gz"
  sha256 "cf9277fa07ce77fec5df24f2c7bf892bb70387cf7a3333812123a849dda3462b"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "328a988a1046cab720fb674a42a8f93b7deb8faf995a2ad8b9208f10835c93ba"
    sha256 cellar: :any,                 arm64_sonoma:  "05e9cb54853192a4e9d58a316487048907c0eed06099d50d84fdd9f4acbe7f43"
    sha256 cellar: :any,                 arm64_ventura: "4f9df1a275f231693181dc49e69785e5e0d96e8a04421c9f4cbd0c90fe658b49"
    sha256 cellar: :any,                 sonoma:        "8ec5b59b944145219c525f89be80e87b3d394ccd03cff373dcfac2dca6b96936"
    sha256 cellar: :any,                 ventura:       "eb6b1c5121ad28a183e5524b0b8cbee0bfcdd9aa6e6e8386a4c3b947a17817a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2faad7991499747e4de4501a08cb9120f166d50ab6135f0c0ebd3abd7046f2fd"
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