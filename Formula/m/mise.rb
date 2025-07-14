class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.7.tar.gz"
  sha256 "d3a32921ab85baa798593fa4c149f35bfc4685aa70b8e4b9e84c8d10370b1844"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a62c57edbe0fbb5faa462291b5c6e9618aeca665b2a8ec238ffbd07f620fe834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5df8e03657301a30d3e29a31baff334d47eb6e6d6fb2a0961e118d3b1c8a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b94ce29015dc5b17b9e1fb704df6afa82d16000fb2847e0b15401f1eee66ec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0cccf71795638dca385b30bdc15c213e08b0320675cebd0348bb7e43da3cad"
    sha256 cellar: :any_skip_relocation, ventura:       "49acdd6faca1b34070674cd02a9ec89f55368d689fca66e9d69e13e3fcf86c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f471d5c9afa7b16ce9097d0715019eeccee63b55b4870b238d2c50dc06d65adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb31a87bd927a122f76d779d9f99b41aa0b64d2f8527f529cb5d071dbe9a5300"
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