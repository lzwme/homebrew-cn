class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.12.tar.gz"
  sha256 "19e0df02706b1f00118d3405e621643155dc702e84645634a87ddcb964b33a1a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cb573e465fa1cc365acb55611cbfac13692efe6aa33b4425567a536f4525b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32b272b868bcd3656eac4a8275a0403ba7d3cdae4f7d21c2ae1e295378c0022d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5f68de026cb59e7ebc1126f784a66d81e26d352ba9387120fb04b8a86d156c"
    sha256 cellar: :any_skip_relocation, sonoma:         "45db118d5ea942bdda0f3da77e8a3cb425050bc2942ba91a76ec90e5320a0ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "8ce6e4c1b4a83304c40cebd533d6239048cfd168da13ed0da8e91a37928b569d"
    sha256 cellar: :any_skip_relocation, monterey:       "97b06e5042dfaad14537ca8a9fc0ee8b1e1394a4f61e8a7d6f3197526e273528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf17593a2178b8eaa12ab73f5b282e408c1b6147c098843fd163440c81650dd"
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