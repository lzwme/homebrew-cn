class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.8.tar.gz"
  sha256 "ea25f6880b525c4a8444b69b7380f2f7d863784877b469c8257900ea48b37cb6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4815653d01632fa0361cbb4090be69c8f2fd1a8e859ed948acaba4cfeeaf7cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1b683a17f8fab934c1de977bb5d617baa469c32504fa3fdbc447ce04612ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40388bff9b1bbbe50cbb8c1075f67fc18053adac71670e5c09071782b001e34c"
    sha256 cellar: :any_skip_relocation, sonoma:        "088cdf6a119fdb015a7606fc6f49d9f2c77b6ba5eaabb909c0cc569bec9d91ea"
    sha256 cellar: :any_skip_relocation, ventura:       "ea27851e21aed61c7ed663d948c7bad54cf6485c6d87afd8a05a987edd9ac2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908c2e317f1ce91c8eafbc3ebfbbd7e3510cbde736c7201850597162b9ff504d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9510d5b5451840c075de4fa194cea705fe189fe1db1dea335f3fcff549431d5"
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