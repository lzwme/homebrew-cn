class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.4.tar.gz"
  sha256 "0329b4a55f892dd7e195581f717bf85631d75541bb64b407d6ca39151199f5f8"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1eded82295189f02ffff8e5c80785dbe23255f37f4986cfa731a2b095b06957c"
    sha256 cellar: :any,                 arm64_sonoma:  "bd27a88f037c44ea469321028da60c55ffd3e68f9965fb2783893c1ec654a257"
    sha256 cellar: :any,                 arm64_ventura: "ed3f6364633f1fd39dde2b62a002f8f0386c7a1d2894f1baa9db72d107362050"
    sha256 cellar: :any,                 sonoma:        "793158d3946005a6865e47380479d0bf01f325bcdcd5c7f5008189955d2123c7"
    sha256 cellar: :any,                 ventura:       "b023093ade9b31c3e52d85d24cc28609beaebfedd7c54e0cebe333eb59198c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3cd81f6d5f7f38bb5ea00561040431d24bbe78c718b39457eda6a67b5b8209"
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