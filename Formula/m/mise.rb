class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.14.tar.gz"
  sha256 "aaae94bff1df40ee0a337e465b355ee1749433c54b669bef89562cb50be77613"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a6f669b1415dc09320c8cd89d1b37aa748f2bf46a3c3c62064f101a33e1075a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64fdb76692059eaece82b410fbc36572deff83664329cd0e58148864ee43fc6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d29bb273146fcdac431dbe7fc1d1bf82ef15aa2bb048b4d611b90c0543de66cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c98e4f219cf719a19cb5f80dcadbf771d89dcf26532777febf09901c33a0495"
    sha256 cellar: :any_skip_relocation, ventura:       "459a9c68c56f48a2fa5115a99b96f9816aa6229ba2da7f0d4a2ef449b4be915f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3849f48f80d9453e44ef4b2d692dfe6782b3caabc679b739b0683ad544032dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0788bc7bf6217874a889532bd7f757e82cc83f2d545e0dfe1d3b80c38599c3ff"
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
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end