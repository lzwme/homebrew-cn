class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.10.tar.gz"
  sha256 "ee2ef8092884c66840bc4fe0af1dfbe1a71bfad3e6278cad307ac0d6d03e35cc"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72b5843d322714f3c5541fc1947f65360199ad9f29078ab5872f0b6bb4cbfe6f"
    sha256 cellar: :any,                 arm64_sonoma:  "032d02f7b9455e5fc5c281aa27c5e497fca2dbb171bd36c6fdfddb4f53ba71a4"
    sha256 cellar: :any,                 arm64_ventura: "e5d6f7145864616257918c7789991dfe3e8eca97dfe5f1ac57892c0c6de6ad40"
    sha256 cellar: :any,                 sonoma:        "d82a253b6b5e83e927540e993cb3dafeb663378089438261bb9af2025dc5ab81"
    sha256 cellar: :any,                 ventura:       "f70ffef6825d6eaee3d485da3fe2596fd2324ac1cd101737dc63a1d659be2948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a2d7355bc163dbb81224dfedefdc018209ab1ee2e0c4d5e4183959066f7c6a"
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