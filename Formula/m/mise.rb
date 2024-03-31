class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.3.11.tar.gz"
  sha256 "4fdb1d6d779d6ca29bfa9a6eaf4325ea86d77685acda6e20d2dfc1aff2cc71ba"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ccc2946ac8d9af9fdde8ce0ef8d9271010eee24f8824086134533480b95b69f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e87fe7f49fa24545c99bcefc1fd1a22edfa6426b8c59e349bd445ced8544dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0deb90ea8214e22f4f10fa53ef8d90b66c769f4784807ce99614c6c3a97b43"
    sha256 cellar: :any_skip_relocation, sonoma:         "458438873c3a621d77849261f7ef57173670bdf0a64e018592e1682685be28ce"
    sha256 cellar: :any_skip_relocation, ventura:        "55196d84f5fc7d1b56dd03943dd8744a23e064b78928ebc4de85d8659a71c9ca"
    sha256 cellar: :any_skip_relocation, monterey:       "31c0c0ca68d7b2d3d12492c97a7e36547c88cddc8c6e195a3a4fb7b443a74f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e003f7841847029e38986685ec809b9a6eab9b66409e6baad4e568860a23aa"
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