class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.7.tar.gz"
  sha256 "58fec67bacbd6c92a9a2fcaa759fa501c4c9b165cc6a64b369d958122f36c92f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6da1652e081547a6ebe735ece8a46cf5697a4def98d4a29fa4721deaefa819bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b173516868c0d6faa6d313237e4356fa776e8da967e4af840e0286417313b20a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5efb615ca429ce11e7924da0788a39a3b423a229718f75936922228f1a87ccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b897df2772df8b94f1178efa2fb16bacecc1748665aa858a63e3a824a68b382"
    sha256 cellar: :any_skip_relocation, ventura:        "4d09c31751a620ca35abdc1ce2a14900501e71ca4989e96863459e27023d43de"
    sha256 cellar: :any_skip_relocation, monterey:       "763662b30749d504178bf371aae0835622fabfdd692b819dd00506efe363bbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257f147359f94425fb44ab6e03ad8b0492a49ea20f0b9431890937a9282b3b20"
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