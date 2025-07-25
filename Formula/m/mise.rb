class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.27.tar.gz"
  sha256 "5570cef677c5759fa7da6f961b58dcab37615a939f2738748af4d8ad86df921f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397d69d1a00f89d9eec8f6ffb6e2df49eba3d002976705834f11825f47ea87a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720b9554ce033cdc6f3c7d000a3880654131b73f392b63d8c67049259f77f4f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "986d48394f697e6ac2e6dc975919366e1aefa25c7ff84619aa6a4997b8a533cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a1329800dd31806b3b76743db19b7318de395fd1e3db40ebc246b21cafaa27"
    sha256 cellar: :any_skip_relocation, ventura:       "4bf32ea8441d4409c501390689e7dc617b8fc722806846f58fba0b46c6d73cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8770fefcfc0d7257f73775924d877c391348404d5deeb08c51523a01d640a5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6ad69bba8c490991200d31b0bf681caddc4237de066ca877e0dea184b59e11"
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