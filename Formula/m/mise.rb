class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.21.tar.gz"
  sha256 "902fec9992f038201ebc9392139368962eae742a0814832bd4da34eb03ac257c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79a94c1b0baca10ad528812c3ab5a13c80bae3c83cd9f33660339e01ff1ae75c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9798c70f09701630ef81129d48b4f17f9f5677bf4257edd3993adcad08c66aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4f0b002d7cc7bdc74c9ccb87eda126740931d02a592fe18b3c8bcbfe3243a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5537aa826727d462327dddac1845ac54bd3212ec8aad5a83d730d665a232bc00"
    sha256 cellar: :any_skip_relocation, ventura:        "00f6147f81af663846f8588bc55ecef04c45c523f0779837c8f86f0a41a71762"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9d6c3d089048224846ea33e572a29f52fac9431ae45948deb8167cd323352f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c5b79e559b2081cc436089e0935c430e46a0df13fc42e60f8e53ba30e57620"
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