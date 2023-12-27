class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxrtx"
  url "https:github.comjdxrtxarchiverefstagsv2023.12.39.tar.gz"
  sha256 "30c50659e46e28822920871a1057c6874ae0f8803592e58d6818881774903e8e"
  license "MIT"
  head "https:github.comjdxrtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "452c4b321bd0fa7d48707c33803a326fabc928134ba6e6ee40ff92ed8e715cbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d156f76331dc54ad8a863c58024faceb7013d416126872e17e2bf831319e11fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63ff623b526412525a81f3e8de911c88e8a3a4596a4341e54201fb235c3ae2d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8afb6120cec2dc929ad3268e76e48740f12a7c123ee3287413795ac2928c4908"
    sha256 cellar: :any_skip_relocation, ventura:        "2292597e79a67d768ab2841c4a1db8df0835ce8d65e7ad58f37a9e8c1587e239"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7b2b25f3507767308d71532596ed31f24a1ffeda540cd8758c8ac0ae97cb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab9838948312c8bed08581b90106f0f13d3d727e6f1c881250c175ca7142eff"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1rtx.1"
    generate_completions_from_executable(bin"rtx", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}rtx activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, rtx will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}rtx exec nodejs@18.13.0 -- node -v")
  end
end