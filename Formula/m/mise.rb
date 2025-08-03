class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.2.tar.gz"
  sha256 "79d64e732d0d15dd54408cc217b79be1116eb16cfa1b18411dbbd03919357883"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e061e7d91eaea73f283082ec724c13ed9615a4f75c71438220bb8887933196f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d74a8680160c06a1ef6075684b68f0c97c75d4df0886089922dd1e68aab992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ceceeebe17375aeb850b235a85fdf830bfdf7d9dbdf0657377f33852d2e443e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b9d5a7f60d9295ed671d84ab8536eb0e926f31a433421913c2c42fcb49f3396"
    sha256 cellar: :any_skip_relocation, ventura:       "7dc299f893679b3765ff59e01f82cfd505dd1d39ee1d3e03a9115edff6bddf9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "750fde46f8158ba37b961460f10ab4414c742cdc54a81138e9de95b3748f136a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2566af82b90464c4f9e2be6080fd4e7735b68df187038b409c492dcd0ce267f5"
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