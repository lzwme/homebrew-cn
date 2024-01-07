class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.7.tar.gz"
  sha256 "9e10bedbf9af5177772322dbfbed2d382f25a1e0536937b053d5836beaa0376c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e654f78f67c6dc9bff31162009ba43309c755fa798a259874077c71ce983ffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29a11b7407b34ce1082f49cf9f1c16fb11d52cba1fe8f94dea3502e03f0ae3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d662a2a53a76bdddef7f7932cbf31844cf1558186b3b745447cc0f18fca1dd7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "71d2997a1483659be330d43a23838906c62657f9fe1aed15a10a744bbd70d1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "945a65b9c809f0b570f428a0bf4ef1811ee87270ad14e9786d54cedae295152c"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3110541e1faba655e6ca96e510dbd0e7298a7ac6a74a569b6ce19adc27099d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30019c41dfde42d8de7d1f93b218c4591aa81e5b992349eaf448366623a7324"
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