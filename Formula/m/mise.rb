class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.11.tar.gz"
  sha256 "749fee7aacdf4aa104593a43dfbd711e887f22f673eaa08c7b955c9327d84f9f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79afcc5b31fdd1516484bc19df434c05bcd518629e9ca1296d5c00f0825d4414"
    sha256 cellar: :any,                 arm64_sonoma:  "79304e3fa320eddc0be631ea384651835042abf6f5169bd479d883fd5ca3077f"
    sha256 cellar: :any,                 arm64_ventura: "ef888ff756f9869cbf01f8738c8159f7808f96e18a25ec2797a14c20856d5dcc"
    sha256 cellar: :any,                 sonoma:        "e92d4ce6c8a5a0355230bc0a870b5283369b854bda8b5c5889f2881884c20db9"
    sha256 cellar: :any,                 ventura:       "05122d486fceec5c9f6994d5d7319bc0f80cc0217cbe718e84e5c851a26b9a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d74bf56ba981314b61ee51bcd0989c5c2809aef2f666ffdf73cbbd8d7d9f525"
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