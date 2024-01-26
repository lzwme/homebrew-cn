class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.26.tar.gz"
  sha256 "c826fcd5e7b44d76f0289f2332252bf08c1d83b6cef8c6fd04717de5060d9630"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bb92e42f5e175f511c3ac7e000d4e29c90ee63a9f5cc44728fd7b4c30273469"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08e392ca7ca7931d72c4dbcf4703d49664dd970b1d2e20c94a7db0660ab08fef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e62538898504c104759efecd5eaa527e211a9c58023d5da23a369165cf1d4ff8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a05cd000105d979a95b900bed7345c2b985eb55d998fc26d64932f2397503d03"
    sha256 cellar: :any_skip_relocation, ventura:        "ed383584f14604267578ca48f5df5e74ae6c1e232ca6fda0a0b1fb5c3a485a88"
    sha256 cellar: :any_skip_relocation, monterey:       "bd221e062b84429576f1ed7ae73b462c82f81b131c397d9be67fc70cff4cf622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ddc82ea4299f66c35fe1e5a82781126546cab023ba243ff4542fa8ef47cc5b"
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