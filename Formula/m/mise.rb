class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.15.tar.gz"
  sha256 "bf1185a106a41f8f6d433310c42b2dd0d179b646284ccfdacd44175e554d8f38"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6398c8973e6d55b8f67b046b6795a15bb407c9a7622ef9846b5a906a8c978c5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013efc3bd24ffe4cf987b16a9b20ae8af3113428146d0596bcc62c77f2c4a979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c088e19c35b21cb5c293a1ffe1b368209de280e742b84050d35a1d02129e728"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f3cd8f07ad4d88f725e6a37d815982e529b32eba63cc9955091a82752e22309"
    sha256 cellar: :any_skip_relocation, ventura:        "efd936bfbed7ecf4071352c9a853fab9bdbfc98f091db044a42acc4af48eaeb6"
    sha256 cellar: :any_skip_relocation, monterey:       "c61c013fbc78f165dd6cdb0519c8e82c4b4206ab5ccc4e5ab0c0c60c35b46ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a32f526104f63d8159c3b171e58e4c56332a86863deabe61596c471cf715f3d2"
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