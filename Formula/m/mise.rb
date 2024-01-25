class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.25.tar.gz"
  sha256 "dfff213c5bf1d59384dce3e63141d7e6cafd4795d0ff401b57f9f20a8ec9c47f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44e6e06bc45c6cedd01c273749a3ee0e46e1523ee74988f9e731f637825bd6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8578c7e991c49fd076c3a30e568c96af6be940a7e4a328740b30a69a344095f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7855d345f36b187e7af1257a507b8bfa5acbcb1a2a592b233cc6748b7d4c38e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d543475c7518f76afa6c63b05351e1a2761ee8d8ce679a877915dde768b5db07"
    sha256 cellar: :any_skip_relocation, ventura:        "cb532a996a30d8166bf8ec0e6a0c9069967c0bc1428893c95a8d56bf3236ebf2"
    sha256 cellar: :any_skip_relocation, monterey:       "870ab1bd8e98e53d2a17cc8452906e381387e7e6c2bff1b96b524384e20a9c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2d87fa25b823f9e69b188409c5e2854739bff1ea4e04a2f6fca7d3da39aad9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}mise exec nodejs@18.13.0 -- node -v")
  end
end