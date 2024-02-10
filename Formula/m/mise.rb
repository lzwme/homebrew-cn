class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.8.tar.gz"
  sha256 "a7ac380b09e6e954f1273377983ffdc018a45d688ecd29d464686218886a060c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d0029749a17da89116760c066945f988580673a50651ddb21581a9ab89b02fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33983fe4657fcba915c1dd148c24b494f56b407f9888494eaef4c0631d7a9190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09fded18e18b4bf5fa4c24dc135e5d6d24dad2447697fa4bd6e0a13e365f504e"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d0c1e0a4d8bda7d3d58e3feaf9fa61aec707b2427f0f5e1155dff9359c70c4"
    sha256 cellar: :any_skip_relocation, ventura:        "cf431b6e3f3b98e86c13bc85a2cff3864a75b414d49079f1f9867de83adbb9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "c9b516760fa06d747dbba30b908664bc43933ba2244138e6cba6d1f0f995d51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07395f1412a437667e69ee7407e552f6484416100936274c17a4219c499ecb43"
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