class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.5.tar.gz"
  sha256 "6ac35ea90bed5ee28db23a85877839a7043b414ba70a3127df712b1e6e82a5a2"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde523a1d6934b1a43691b78c45f2f17d00e943c27f74010f6768ddc600ce50e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a769accfb2095e959dbc362ceb127bcdc70757195e5c2f159177db53335229d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c16671d7c9aeb6718399e0c3581f1c367965097e8a82aa4dc82db357cf6e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "de644e4d0960d84a1d9fd930618bcf19cd045a13027cb38464dc81ed63fa2cbe"
    sha256 cellar: :any_skip_relocation, ventura:       "651c6c68d1f7448844bbd26b597843197e9dfa57b892c41e82544cf0e3e8bbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b5f4dd62ec34e2a59f235dc5dfb950953befa4d00dc25c3520f3cdbfc9f924c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792372aa18cb323dbaec28a61f64a015d83c2611a30cafa1d49b803acb9d690c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end