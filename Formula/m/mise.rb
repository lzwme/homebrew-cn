class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.27.tar.gz"
  sha256 "527c45abc2aef4e8d010deaff9e0f7c66609d70a3cc90f8c039d3188c4b1020c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bd8bb476ef0eabc3528f84ee0e040805d65f425bc39af1b6207ba81b8201fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c0f150be3ec9585bf1a3a3420f55cd9a9963bc26b90ef7b6c1756c2ea1066db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfd6ebd56af14659e61ff42a2d2e7bbfa64201580136c68e652921b8b094e658"
    sha256 cellar: :any_skip_relocation, sonoma:         "33a8118863d273ab4246d8c039be10164a027a273868205c0913d87414378a5c"
    sha256 cellar: :any_skip_relocation, ventura:        "73d624a9f34b5ffa142e7afd8a19b7ce383af0b773a2010ffdf32fdf542e6152"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5988ed550e46588a70fa9fb8ce2e629f373bdebb3e45a7ce6eff6031dc38fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced96bfb0ac5b5d113929739feef248d877e4e22c4d54d96ee6e419fb3c1fafe"
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