class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.6.6.tar.gz"
  sha256 "757f4e5a8196a58d50a813306cbd50c25d975a4ed0b87f8ec1188308757f5569"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6109c9b5b7b05fca83e1a45b4340ae4f3235b115fa45ea37b0e5217e06b4277b"
    sha256 cellar: :any,                 arm64_ventura:  "c42efac3059222f50b13c041a83ef1e639b21e8d0eb689031b47cffa4a83b70f"
    sha256 cellar: :any,                 arm64_monterey: "1d09d916efdac9ef88bbae397b821d75b49d19850e4eba10f8583a32b90f9398"
    sha256 cellar: :any,                 sonoma:         "201308e2318c3dc65abe19a87d8f80be50d1a3ad953e766877ff50c8379b7ce7"
    sha256 cellar: :any,                 ventura:        "711810737a5d206e0eafa64e5dfcd21ef38d378ffa445afa0849fba222d51ead"
    sha256 cellar: :any,                 monterey:       "80075b8b059632756b750f4b8b90e0d4d9b6c3c901ac63ae5ebcfe20a6af4096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2250ae89f6814afdbd0dca68d6cb92fc674f956c4c06c86dcbe9fc0ed44e635b"
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