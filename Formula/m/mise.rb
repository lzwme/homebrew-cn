class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.12.tar.gz"
  sha256 "55a9b21296e9a0b0131865efa7e0ec0d61d7c86d9e93758cb0f9062b1b795b44"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dfc8ead3f1faf11dd6a427c7b98067df90162a3a41cea400a85ae5a47367fd31"
    sha256 cellar: :any,                 arm64_ventura:  "01421216a6fc38045b05da16bd53cf6c18435ae4a90fc364f9fdb26d5605409d"
    sha256 cellar: :any,                 arm64_monterey: "28ae0b7c2a9301f78506413b012c132b68694f929366c73a71168b6f54f5d741"
    sha256 cellar: :any,                 sonoma:         "e1469f4350e731e7cb276d05eace088c70d01695607fcf84a7150e3e6f888af6"
    sha256 cellar: :any,                 ventura:        "2e70083bec9be4819555b634609e83a9ab01275b21f082f520fbd6690318b4fb"
    sha256 cellar: :any,                 monterey:       "1790169b7f510afe58240fa5c6525d22779e2a0cd1a69c8e7fa0b56733719793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac61d8071199930d41a325e407e6b0dd29768080baced71e2fb4655a2430ccaa"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

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