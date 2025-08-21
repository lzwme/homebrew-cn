class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.14.tar.gz"
  sha256 "fa02ea0d7f7b88a748a361be42c74eeef3affb4cf574c8526c25e2195c3ab809"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098cbeb37425631312e10a8c4a7212b0b3ae8b2e616549037d3c84d79c092c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db95f207beed5390971578de3554624d7d019731a0e27272ffd4190480006c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a24d453485b9bac358f4219a002d179a0696ebcf4e9bd76d21b099230513b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5f86968be363894384efa7361b1bce40a658b748d67b2c125b823587089f93"
    sha256 cellar: :any_skip_relocation, ventura:       "c799f192bb5af22bb37ee466e63c8a4083ea71b2dc3d80f8b933c9064310dad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3138316e10ae9aa577c5fff09f2eab4e3f65a9d10e95521dd1d778927af420eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7524eeaa7ea23b0815ec0ced8d5940a35dfb818c9c611c5691daee82bf02db1"
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
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end