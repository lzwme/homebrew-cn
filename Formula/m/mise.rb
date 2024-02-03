class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.2.3.tar.gz"
  sha256 "b23a4e99b39eb1c45c14feb76ad344d90576c42df28274b4e37163dceb33a8ba"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64a955f01f9305db66afc0a4edde241f6e43de0f347658b769b2e8b79a58818b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c4c13a8fdb921d5889bb54a962d3bb347d5cc92d7cf9f43cfb0fc9b4a956ada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c666011542a4449da6ff41beb179d114fe1aee66f594d48656cd6dcdf65983b"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d2e3bb09f91d161c2ea449b718e7431c813a5e57000ceda6d68848eb92a7c2"
    sha256 cellar: :any_skip_relocation, ventura:        "5e989a28c6bb9c302a4968a26d608be8c6a2dab792173bee7ac9b660975378c1"
    sha256 cellar: :any_skip_relocation, monterey:       "54765a46142840a43a607cefdbfb087b2e06bef64d638d2cf79fc76b2f8616f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99eff7f1c4c40fbc1bc60a68c74dd85efa6b491d985502d27002033c9e0fc85b"
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