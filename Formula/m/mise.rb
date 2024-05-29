class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.24.tar.gz"
  sha256 "0437fdc2b0f499b7c29d8205fd0d9ec3e6c64ad0b7b4d582527553eaf74ced22"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "62afd81914dfc1f0a57228c1119832dee8260d692fda6a14aac71f2fc2b3dfea"
    sha256 cellar: :any,                 arm64_ventura:  "d7bbe22fcc644397adaa007020867029cb4af9024506e189f90b03da25ebb3fb"
    sha256 cellar: :any,                 arm64_monterey: "ea43eadb6c1c0ed03ae3a6290f6ff31152993e60bd84a753085ec431ba25b05f"
    sha256 cellar: :any,                 sonoma:         "21538284fdfad54854df901447cf6ca925a6fcfa9994499ae8fe24c00eeb6a22"
    sha256 cellar: :any,                 ventura:        "378f3302e76dfe400b17e874de2d261a86fc79876184f8dcc82f61b64b1aaa09"
    sha256 cellar: :any,                 monterey:       "cd846a518c066acac822a09e1b8649e74d74999d9e63ac40aeeb113b4087f280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9431637d192921f02ee668f0cf5b09d4886393eefef1640f890d527a3fb153a9"
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