class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.5.tar.gz"
  sha256 "19294d91b7f54510a28ec0fe27211bdb0780c9a669b0df6acb3e3c02f1a89958"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f8914ddb9d8d64d7bed3b4bed161fd3fffbf0553c59f2faee5be37dff4acb1d"
    sha256 cellar: :any,                 arm64_sonoma:  "bb2b0d0a5bd9d2908a23d233e498c815116a1fe995f8acc3fa5169df71a177d9"
    sha256 cellar: :any,                 arm64_ventura: "56f2f8829f60a933d3132797b37f4dc47f97eb349b0460388d8e79183aa7923f"
    sha256 cellar: :any,                 sonoma:        "70bd2c12ea23e3a09777dd7680caf1345d31d9c1cf650648f4a805abd3196581"
    sha256 cellar: :any,                 ventura:       "6669a38f02ec4f2134fe813a994d29337bdc79ab8715cb94da988176019f99d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550d6bce8db06584e5143b32448cde88d9867d5f0d8c0d831b6e5d188ef2cde0"
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