class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.9.tar.gz"
  sha256 "2538570cd9e3b83a8b1eec733a7d2b9a2ff2df34c72c897ad8dcca17c96f2dd9"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9760974e9770c33a36e8b9959d5fdeb86b02860a7ccb96f99b1eb3712eb910c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa84a02864e94e8829e43a9b69eae5d7903a30b501507a4e239aecb159674507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c1432f6d3e80c05eb7f5e1b0ff437704f59c5920858266fb00b54b38958f79"
    sha256 cellar: :any_skip_relocation, sonoma:         "20ae65faa1ffd1b3bbd02d655bbb847502af6b054c3a2f434bae81ffea9376c4"
    sha256 cellar: :any_skip_relocation, ventura:        "949af1a9db3f5609ea19f9aafee0ddd90c94d806e20a0e594b170efc009b3da2"
    sha256 cellar: :any_skip_relocation, monterey:       "d1eea039d0ab364e1ef5eea84829295486378f9d9ac1aadba83677a6453cffcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bde84eab80011762ef09f110c151405be2a2de0e3ede804bcbad24f19d8d84a"
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