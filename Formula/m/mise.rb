class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.17.tar.gz"
  sha256 "8040aeebd807e6054b1f32d85b3f262aea71f17f84a11551da87565255558770"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a1b288dc1a3848cb799cf77f7126fc8309e938b6d668394aca391c72a36ced0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3230dd289c719f40da00f19fab18e490e4329908ada998be006ae46c6aa2f8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f7b41c7a0cd79b2bb9f4682d1cd6ea3a7da36cb43a24130a9f94d80e0e1818"
    sha256 cellar: :any_skip_relocation, sonoma:         "694cf830708e83862331aa58be4470af5551c4f8ce160390f15754d5d26678b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3686ddcf480e0da9654adb298d96505bf11dd872737b0aba127f0aa0b03acb64"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c8bbc38c727cd5038fa74c3e47f16fe44385961e26925bce20bb726225f248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2cc25a9dd3e62cba27cf116a09ad5fb3a3d157b53dd59a0a410e6504a991a9"
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