class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.10.tar.gz"
  sha256 "93f2a848c7682b3905edb98bce8879d9a48dca49a5466afec85d970b44b4e361"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed5edd157fd203303d00cfabfc283dac0b372f444e20bb373c6c266a81905fc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9b968bbab9b8370533b096ab1229123f2106d65958d4e7d40225fba76ca8bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a760cc911bf788695bd8b9dc678f6e628750d1180ad0431882243fff3a59582f"
    sha256 cellar: :any,                 arm64_linux:       "a562127c066da0c9e447f4832f6b9e0194bfde64f248a02507c560cf29b6e3e8"
    sha256 cellar: :any,                 x86_64_linux:      "7050ab3ee71be835499dd337e62525b021ec469e5889336c934e042259b329c1"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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