class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.2.tar.gz"
  sha256 "fcf1e472900f74e8df2e0612300bcedbbf110b9797f5fc7522e5652cfd8eca08"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50b61b3ff571860cac1dbb634c4c1168b656d188615da4cdb430876317f8838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0355366f3cd7a4f074255b823a07cd3048d27deb444def510fd0932587ca769e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27b97bf9c1da10e34d385f84cf59e27631da5961471d741bb5684a73810c374f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56c5d44abb624d0fc4408854ee7ee296f0037e882395c56375733e44001a8c9"
    sha256 cellar: :any_skip_relocation, ventura:       "363f1f1957cb36a7cd2a731ae1781fa843ef3691818efec228798198ffe16487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3b6806937fd9b5d689b30ae415112073621091392b893c05c2ab3f31aa29e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4275cec7e52bc3d86fa3bc01914081d36d2ee175cd20388cd3e40ec76c6f1f4d"
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