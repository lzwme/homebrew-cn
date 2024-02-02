class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.2.1.tar.gz"
  sha256 "8b06c3c5da4e87761916ccf86729ed60aa7d45cf470c457ceba0f9150fe3dc20"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4baf64086f7cefdf5804d847f9e8f003dbe577c732dd044b82f0928ab451d0a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf321d3ec95764b2b43d8cf83895430c01dae0f0dde76915ccac6796d7ec1376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fd8fd8564c1ca3e33752d4cb86eeee14ae1a7e4e9c056194c8e94d34bb5d98"
    sha256 cellar: :any_skip_relocation, sonoma:         "609a9675497b1d87602ff8e0db2513385d30e87a65b20b6d046fb4772fc494c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a7577e775c91908d364a7d0386d6661d1a4f168b1c4ffb5cec071ec7f0e36119"
    sha256 cellar: :any_skip_relocation, monterey:       "1fbfd5dbb98b9516f57f8f30f8eb8a48665afccec3863a32c6496e2cb3061d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03676fff6bb6749bcc22207e7f7383951527ffc1036f171e4d8fbc9b0a9ece4b"
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