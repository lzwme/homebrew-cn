class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.16.tar.gz"
  sha256 "e9e0d53762511b9e3bfa44404813e6725eca8a2bae391de961a7ad42f73d4a64"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ba76a5b9977a128cb32e5c4c68e7a7eb7d67c89092a755871f9eba9d84b530a"
    sha256 cellar: :any,                 arm64_ventura:  "ead235782990a57e4542ece482e14e395ccd869980dda14bc1a8846ff141e654"
    sha256 cellar: :any,                 arm64_monterey: "f7c1ab41e5b29ef3cd92c0df93aee8f78f6a3991faddff44ffe77c1a2c8a0ea7"
    sha256 cellar: :any,                 sonoma:         "c6b992545196445cb2339f55ad9f8aa0dd97e2027639217aaebe180f19952189"
    sha256 cellar: :any,                 ventura:        "d874e45f6c24a2d8629902899bf7fb48cb964ec5ac91ab27cb3703a9c103a3ce"
    sha256 cellar: :any,                 monterey:       "46f1fccc848e87438415ebc902932599490e54afc1850ee8361bcf9118b7598b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6332998785487426759d43d71aae38dc7d99812faa7dd4abce923b0a239517f4"
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
    system "#{bin}mise", "install", "nodejs@22.1.0"
    assert_match "v22.1.0", shell_output("#{bin}mise exec nodejs@22.1.0 -- node -v")

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