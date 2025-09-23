class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.15.tar.gz"
  sha256 "5afb6908c4bd46c102c67d15bca51eb67639b411943a5210ebc342c3fdde10cc"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f515d35f36421d7f2c2fb975ab5e660ab9b44844e80dfadae333358665f53c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f58d951473dd666e21325c87bc1b36f17564fd192cc251973fc4dac048f0dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8479f9dde72821e0e125b585efb81b8db555468a32312d8f3bb2bbb23fde09"
    sha256 cellar: :any_skip_relocation, sonoma:        "84abfd663d2df18161d3e1bab34ef6c5e6cf33a600df05375fbd8e13c475b8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6003a68f649785ae71fd04408fffa0d4256e7c5ac6a0a7faab6957f6c3e56595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8116c88a08726a7f5e0e3cef79e99aacad249cd5a2192e7986c2a96e33c41ea6"
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