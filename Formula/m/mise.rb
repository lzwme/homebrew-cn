class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.15.tar.gz"
  sha256 "fa6abb21beab067d7bdad11f1d809c60f9b3e78f019e6678fac37271fa0a6c56"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba2cd05c1c92d5de33fe9b7409ec284d1325e27568ed6bfa2f8925aec6fbd77e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6bc8c083a2b6b4ab62c78be6ebe4425d02815e0970d4d127359fa157dd792f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44cc5d16e694fb6168c05d4901069ccf3bc8da0ca9bc29e6c59b350998164d4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "de0c9f469383b5f75ad2ab3f49a59d450d46f248ea4037d2ac42199c1038d322"
    sha256 cellar: :any_skip_relocation, ventura:        "e3ded46c73357dc6d04be23607fcc9b8f57acd13adc73a85afc475b449dba642"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a724a9e56d6e45d8d260184346d90871e1c2f0dc52c68a4bd0ba27c27e0610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093f2d01d402cf4a7b07ef61a689ac6c5400893b61cde0af6d791b55e354dbde"
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