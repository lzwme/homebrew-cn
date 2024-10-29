class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.13.tar.gz"
  sha256 "e25023b573dbf8f2df2a5fb6372ad82bcf2a2abff6b1f5ceb1922c936099a3a4"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30e06864e7104f99ad35343bbde9bf33919a6d5870ea365508acea5b0f70a318"
    sha256 cellar: :any,                 arm64_sonoma:  "303dc601848ef7a7c326d9266fea818d2e6ca8041d2a4b153004c9535a6fb5bf"
    sha256 cellar: :any,                 arm64_ventura: "fb46b72caeef93e9a0c3015c59385f9044a2a61d6540e73997c377b5c66a6acc"
    sha256 cellar: :any,                 sonoma:        "1510c4f1e064ae31ad976a99cd36d8e582c0dba99a5ec49f7946bb3bee8ac563"
    sha256 cellar: :any,                 ventura:       "60f963a0b9175e40212ed058a69749313830b0e2e6b3a1e9a8a1e886e94a6ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b8d21a68af343d567d416c5c0d68297c13f390042177adbd2e1b002daa50b0"
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