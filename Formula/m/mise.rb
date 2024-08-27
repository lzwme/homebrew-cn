class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.13.tar.gz"
  sha256 "a93c8db83b302c79056c433f22300c4d910e8eec44a073502c0ebe6cbf2a04a4"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6f1f7120b8e05091a6051021b8a7879460f816e1d0c9eab226ece4f52d60acc"
    sha256 cellar: :any,                 arm64_ventura:  "08a9e67e91a9d6e84dd6702b601ca3fd2ca38d6663bc73a44dbf8cc42c0627b0"
    sha256 cellar: :any,                 arm64_monterey: "0fe0351c66180197dfb5d8a715b20648d2a1c76ec3a5287ec758a79c33e2a771"
    sha256 cellar: :any,                 sonoma:         "d1090e6c6963fcf3dfa153657e913c3f2bb8d6acced2b9ebb8cd3cc9db543d54"
    sha256 cellar: :any,                 ventura:        "18e83e40be286622669e34d089fc49d9b716dc2077c9740bd29f7ab549d6be4a"
    sha256 cellar: :any,                 monterey:       "386a342f6530076ad67685ff52953aa31c50f1137acf1cbccd5a3348254a661b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea380b46363cd374787be0db683817a5392d87673d7f06f3da939fdf74d7c29"
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