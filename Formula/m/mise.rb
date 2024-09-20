class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.6.tar.gz"
  sha256 "c39757cc5bddb3a95c4464a52c21866002a66fa3bccfa0fec9ea01e8d980dc10"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "541e94ee7980b96114110416413321849637ef15f719ac4b01acce075f32e2dd"
    sha256 cellar: :any,                 arm64_sonoma:  "e599455f94425a72e018aea23f5db3213b185b78a52250e3cc5369639f7ed383"
    sha256 cellar: :any,                 arm64_ventura: "0e0b46d2a13f1fbac7d91dd3f1d84ec0d81012750e52c80f5288ffe8019ec4ec"
    sha256 cellar: :any,                 sonoma:        "a3d90aabf07e8a7bad9904d268b402a63717984810f23722841720a237066996"
    sha256 cellar: :any,                 ventura:       "bae5933a6f14c7da5710fe7dea04b998afac02c673fe21aa0db083781e7d7945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59ce2e35cba0b8a401fcb09d100a52e80ff0262131259a2faf317bbc7f266a9"
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