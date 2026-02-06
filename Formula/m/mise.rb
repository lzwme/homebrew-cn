class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.4.tar.gz"
  sha256 "ab3c0b8e8d9087d6b94f5d61c72431d16450985880a2146cc363f62a5794077a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d171deefc52f50c4a8309f2d5083db77028071e451e41c6aea44c61741312e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47d1bc32759288a7ec780f2ccef95f62c2f4c38112d9552b44f0bbd4f9ddcfa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a07cd7118c1e432b5fb761b1cc1c36caa4fdc35bf7787f70ae3f1501f177994"
    sha256 cellar: :any_skip_relocation, sonoma:        "7474a31732d73eb3754e1e5927e4a84c631a5cfd0caff2dfef9e7190409207eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e59268d22ddddbf68e375bbf7aafea469521e46e1bc615fab04e01b6fcd5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909cdd0833c076309a96579d9f301892bb35144886c2d86f0ad1b3d8191333a4"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
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