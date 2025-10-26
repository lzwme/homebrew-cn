class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.18.tar.gz"
  sha256 "987bdf4ad6ea83690827a9ebfa5f6fefa6d6541ab10a1bab7116535f8dcd6235"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33078aa045688700937f4fc3fbb2aace42ad6217ea87614a22e2a66459288d8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d49ab61d3f359e566da6ca87b54084b7705cdcbb6979a98a6d186dfae2b1140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7b19e8ecd59bb7ce316ee0dd4e573e8ceabeafb7118076f52dfca5e8aa4f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b168e13aae3d406ecdf86cdb67999bb1e2ea4a9c163c8dd749ad98dc5435fc98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85023476637b528c2a191c108c814edc861600e0c066517088e1af258fb229b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e09dcb684ae62129ecf4a7b3eeb5c16b05509f4ab6637e5a2e1bfe60627484"
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