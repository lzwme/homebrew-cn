class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.1.tar.gz"
  sha256 "5580aea6e9ded77ae5bb0e02a989ad2d96abc5979891952a315d438a3b498b81"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb01bdddf327ae147b1c337e5a982e1fc3cd03106ba89ddeec5991ff28165db2"
    sha256 cellar: :any,                 arm64_ventura:  "8fa4578a97d695f0463d6c58ff0bcd0febf26cda8c92befc6601a2f1d5e90c94"
    sha256 cellar: :any,                 arm64_monterey: "727cae13bcfc3c26030061ff144a1c7755756978e7dbbe4dc283197e380dad8c"
    sha256 cellar: :any,                 sonoma:         "05bbdbb1f5e499b32a1f4803229266c6f5967e6069cc60c817aa952e4d14e908"
    sha256 cellar: :any,                 ventura:        "7f2fe500ff958b48c83aba08f74f1c3c87c240f193d4292dadc4313255a58840"
    sha256 cellar: :any,                 monterey:       "d5132f3e42a554e18b30d65c63f9eb3b46a8c5a9b136b92f142187eb9263d0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a990c9b9a842a49cf63d9c3f454fd3b49ee532529d77cb266e11129e84bddc24"
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