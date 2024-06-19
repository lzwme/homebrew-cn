class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.6.5.tar.gz"
  sha256 "8972a1de43dabb307bb43cfa0389f86af7e2a608f9cb54906a497e95f99c1517"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87aa515966c47a12606cec2296cf3a7893d44759313772da9cd9b19e7248be6a"
    sha256 cellar: :any,                 arm64_ventura:  "cc3a76f6a4a6a10c1aaec8ecbdcc31a988789d2f5f651fd1ab3018ea84a36e28"
    sha256 cellar: :any,                 arm64_monterey: "72b47683c7f6511eebedb06a8827a615d331f71c86714611d4bb7f918fa94bd7"
    sha256 cellar: :any,                 sonoma:         "7a600262d9fcb21526d874c13d19b28e07ab7732b2cdfbc7babd93c9bc4fe700"
    sha256 cellar: :any,                 ventura:        "a444695fccbd940dbf2b32cffbfe1d8c59fbbb923bcabead4f4bdf2c1b47c7bd"
    sha256 cellar: :any,                 monterey:       "0a26564ccb32a64d8d6a03b5f069e560499425b3fa9a15375e9f517425e826d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f4c62fe56187853a849e0befb7e8060756d5448ec615e4a991c3fd79b59f9f"
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