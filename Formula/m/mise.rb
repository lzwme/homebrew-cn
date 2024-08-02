class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.3.tar.gz"
  sha256 "e86e277e8a136d331667fccb13b1d44fda320271c8956a7bb13c110857990529"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7eccc116e32be14859db8d990cbdc6290990ce608226147c0e73de47245fde53"
    sha256 cellar: :any,                 arm64_ventura:  "9858b5d175416badf81ca1917205dbbfc65446484b92b078242d1a50f5575f7d"
    sha256 cellar: :any,                 arm64_monterey: "6a8533cf84e6b0a756996016ce123c2d080d268078c8b962f75af06904d7a73c"
    sha256 cellar: :any,                 sonoma:         "a48cbc59d38d077677086a5dbb3ff9f5f11109d42aeae9cc1ed25f7f4b3ec13b"
    sha256 cellar: :any,                 ventura:        "0ff8313d3bcde0227d789e3d6e7213bd09473609ba3b025a6e91ffb0e055cdd7"
    sha256 cellar: :any,                 monterey:       "6cd61fb37d0a5f7de244b1c4f368c156609a09b589655c14b7947e3d28b5518f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca230b44b4f93700ae6e2bb832422c1e1200a068c068ff199b220a72f1fbb37"
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