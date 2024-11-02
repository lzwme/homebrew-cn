class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.0.tar.gz"
  sha256 "30c3aa17b76deaa115afed103df3aeb83b95a32c3573e67a4ed3cb5a97c9fd9d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb2579523ac570f4cc373c9623c1fa62909e834ddf8e007fb093f9b390b7cc5c"
    sha256 cellar: :any,                 arm64_sonoma:  "7d43b2832f80bd60553299f9f9deceef178fc1ba76e5ec36c241421263a5e17f"
    sha256 cellar: :any,                 arm64_ventura: "e5d47f9cd70d25a56e09c3525fb60cbb176d05fffa2fca3be3928666bbf7a4a2"
    sha256 cellar: :any,                 sonoma:        "dfa43aaeb00e00a5e181c19367f13277ce4d0d1b8c1219a5423308db56135909"
    sha256 cellar: :any,                 ventura:       "4d7958aa6e028d6d34dfa66e022ce6b05406ef2581fc2f96d20f99e642d48d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b484767cd0f1c37436606a418dbd9a594f9617f314fc5c7de463c41d22ae4eb6"
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