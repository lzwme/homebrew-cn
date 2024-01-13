class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.18.tar.gz"
  sha256 "e72f4342e080e9e1aaef5221f1cd90e32e27a0f7157074c92941268511afb2a5"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b2def1ff1b14a83ceca589c683edd00a23075ac96be459351cd8b7a16876c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "224a52f91b2e3588d99bc5c8ae16202ac8dc93e4bb2a846603e8700552b4c16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719634e7cef66a731003a26edcdcd4a5e39299ce8f96a33e453f97e8b49317ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fc00c25c41424d5b53438439a306cb2d7991c3e9786285911fd2041cfad766a"
    sha256 cellar: :any_skip_relocation, ventura:        "38adfd3db36b55bf52f2f3c8fb5a49a8661d6c76e625cfe80eaa5327b7977be8"
    sha256 cellar: :any_skip_relocation, monterey:       "23f697e4f5127afe61c3178f769747c68f83ee9301f59ec53907c80af7113fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5241bc45d4728d41440d9911a9f4440f295da53626328c6c67178a5d6f83cd32"
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