class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.9.tar.gz"
  sha256 "f2c58c21e6a00ece6cf0c94b4feaae00e49337c8345e2f423650002779ac2737"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f252a1de5ae68f66ea8ec55dd001daa6fcd10048979b74eeabb4fcd7d1047198"
    sha256 cellar: :any,                 arm64_sonoma:  "fb780638e30c6035a2d8e52fc6bacedc8ce39d7c2867fada613bc4aeaf831097"
    sha256 cellar: :any,                 arm64_ventura: "42c512d8498e85a7368e7913484e5f8bfb1020d2fd714b54616c9648b0186c6a"
    sha256 cellar: :any,                 sonoma:        "2a8bb2ee79bd31354786522a09647484b3853f89c6a4444bd754b68cdaa63524"
    sha256 cellar: :any,                 ventura:       "51cb2546ed4ae862960dcc09e549f5f09f24fd0fc78d278c50d2c0b88d84773c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08993ca9ebb06fd7d1827ec87e0f36383649b8d1458b71e67c59f101a19fe797"
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