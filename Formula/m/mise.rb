class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.25.tar.gz"
  sha256 "50916a1186eaabf315bb064e7ea452fa6d8d01a49cf8b7b171cc82d59f2d771c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1f9fd90255f7d82336bb7e4053e5c0d530cbdfd8e794ceba03cf7e042c7ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4670ad1c63e65bf3de89e685048a28a34543f884fe41392aaa001fb9ae2f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b790a04a8ec33b0dd16972e7805e99bbfcb5614cce458d3a8bbf714e1d0d05e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a66fe217861b83c67ff2feab16691783b480ae7755639e08bac024f84e0f230f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c65855dc70e02a1fb4da3647a075956d7a4febcbfd9d0e7c5bea8160216ac7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef361d94ede09ab851088854c289be1d016c88a897809daacc662f94e8dfe98c"
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