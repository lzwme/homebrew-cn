class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.16.tar.gz"
  sha256 "5df101845809e37daf7a5fae83326814923eff48156f35439e96aca76d08c67c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e40abf55b69c1c9a5dcacef9bae5d0290e095eb5584e975e01a6c85d22044b0"
    sha256 cellar: :any,                 arm64_sonoma:  "6084dcdd6a5ac45304d13e933dd00967e82fb72a77ffc835e76a067da59937dc"
    sha256 cellar: :any,                 arm64_ventura: "c3f9772a1458d12385b52b02c8a1737b18773014bee563dd6e27a2ddfd1bf61f"
    sha256 cellar: :any,                 sonoma:        "1b25cf65a296ca778f923a65f40d830d9db2223977125c46747fead7bdae7806"
    sha256 cellar: :any,                 ventura:       "9e13e4e8d72cfd491a616d383a4bed15460b8c27d7f5e846d91dd6ecc49c744a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb4a889d11347298ad08d56b8b9ec5feeed799990e3ed963fda41e8dcdd5089"
  end

  depends_on "pkgconf" => :build
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end