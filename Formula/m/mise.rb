class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.12.4.tar.gz"
  sha256 "bda1dc53b8cd459ec452ff8846a09dfb7559bf50bb2d67b4bfd25aede9f022de"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b0d38a33d323d89a24a666114053b992c0c8baab51286f0a9b1efb01602a337"
    sha256 cellar: :any,                 arm64_sonoma:  "6eecdf47ce08aad568bde99883970335ca4f51eba8e4a3ec040096aec260b9bd"
    sha256 cellar: :any,                 arm64_ventura: "717a6fb1cc7c9015a4fac71e2e169e556d41a10017237ea8819efdf728f2bf88"
    sha256 cellar: :any,                 sonoma:        "b03ca1366d07bdb900f09a217d44f04941f14a93bae2ce10d55c42bfd09ed0c5"
    sha256 cellar: :any,                 ventura:       "8e45a716cc536e02b6cd959fbe57b65eec1382db3f69e33519da9c4c4bec6a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e8e8956e27edb1a5be3f900d110c3d600a75b10dcf404674b7d322cc4795ab"
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