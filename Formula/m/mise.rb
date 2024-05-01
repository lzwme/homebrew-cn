class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.12.tar.gz"
  sha256 "1a30465303a69a2da7214fed1280980ddce67ea34ce2b18e81e1ad60d78cf119"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a4c5f735e129bafda02f374554a59a0aee32fac2200323061c0aed77ab007ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8266d873c5c1bc705d98382974e18159a75ac55b7c146c6813f687fd63c626b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7152f73173b308472bbceb2416afcc8071a9e1e59d00303bd63820c54f94020a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d184fe9d91688be22806728bd8e303819dde16e4c1fdbc91147c16beaa31b2d4"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6f2980b12f29a005ae51fc4490bd0db8c65396832b4889de657d4246eee56b"
    sha256 cellar: :any_skip_relocation, monterey:       "1eed97887acd88b06bae9009dab9cb654e0434c46df1fff04d1e3de0b2010a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ed44b46d066bf025948413d19282136ff439c38431da5e44af20bb18a3e350"
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