class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.9.tar.gz"
  sha256 "ebe4152c0193ed4f3b823b318e47600f8edc5cca1c888e95a2a0435dcc91c544"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f465e6448e387a7f690694b9998dcfec6306bf5dc293f21bdb4c277bf3d7b148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad563e7201e725a5cfd108c45a8ce94ec2c219a9e0017170cb54265ff0265e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c229ca8c43f9bae4744baad986bfabc57e92b5610867f25f4fb7dd3ece62179"
    sha256 cellar: :any_skip_relocation, sonoma:        "9668be231b0169012965d974a7cce0a9a6fbcf7ba2dfa4892c1d78c23fb944b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37fdce9c805938cc79c56b6a72046e2554ed339dda3993b6fd272d2afc83a4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c677cb326cc5ddb36f99f86e5c0b08b17933a72f8fc79031e61ad1089c14faf4"
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