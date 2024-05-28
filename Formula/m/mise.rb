class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.23.tar.gz"
  sha256 "d430b1784a1426cfb7bcce1d447b361478cba34dd9ba5dce8e49274c18dc8151"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59e2956c9547e149e502b885ce2526f6d6e218355898e234601a02813e5b1643"
    sha256 cellar: :any,                 arm64_ventura:  "2b71565660262618f502ad44b7ccb31d3231e65589864416b5d26bf2fef066e9"
    sha256 cellar: :any,                 arm64_monterey: "70b559d7ba049a5be103c4e8e712cf3af29c1bcf0e260442fed308d854a598b8"
    sha256 cellar: :any,                 sonoma:         "f2af246d5de338bd948b584729ade19b7e779d8e9961b0a4542305bd5b9d7e0d"
    sha256 cellar: :any,                 ventura:        "40bf7e33b4ce4afecf41e0fe0c2d0187e0a6ef100b788a8e563335b7d7fe83d4"
    sha256 cellar: :any,                 monterey:       "eb42bf5215066693089e22dcbab6169bf65618e778ec7d7ade8c0a2222694d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b841c2b1fde59f209b7163bbf08df76cccb1c13d92b2dcf402c9201455134176"
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