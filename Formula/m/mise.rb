class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.21.tar.gz"
  sha256 "07275ce0441c834c1bc50a2ac00ccd7b26b02579a4787f4009282834cef21599"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552e5465ed868170d8c666cfa390357905eef26bc33a2b309b1175a41e9327d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb6cff5f669c3fe77659bf4f4e0d5b16da857ec77478a8037be91535c6dd0256"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8a5c1ec2e7631447994f583ec90824f0efc4d3c7e82af98cc4205d6b39e2855"
    sha256 cellar: :any_skip_relocation, sonoma:        "518d0900aeb4e03c276c8978e368023bc53fe0c768555ce71672dca841b9c4eb"
    sha256 cellar: :any_skip_relocation, ventura:       "0d143015a29b52d29d1f5823b2997efc159c022ba4c1743353047fd9fc2504fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed3bb6ad53f6e32820272472479f7da46e6be71070fdd58275f47241961e5022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c97c73709fc7bc682bc6685397f7fcc17ae2e354d043312102979027f5cab30b"
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