class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.2.tar.gz"
  sha256 "3a025e84b12b7b1aa8314b64ecd0f8dc0ff63d0c43eab4fc13ed2c89bf724ccf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcecf257ccf99bddb813d68eeed336a6e7e4fcf14e021e222389e38aaabd11b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef47ba22858e230cca774cc2f08e8cde457f7cdef1335ac2309d689cda5bf00a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1afc0ec8057a72082d16a0be0560512d6b2aff21353501032e0364104f1224"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a5d843b90604d4991e49ffbfab5dd4842bcd403425e5047b6e993dfc7e7217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35c25575726f21a4d1c56b8a8fa3bdb5bd9cebdd18c721c83d6ac3d67abfc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b1fcf79d19ec58c49e0c589bfd3be99e582f4fe90a662d3f2c7a11b2998fef"
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