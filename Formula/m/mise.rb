class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.6.tar.gz"
  sha256 "f6d05a50d4cc14b8aeb1a462eaed0f6e607a2bbbe7d58e1393a456e3b22b8fdf"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7333f9e5bdb2fabea081f016d98deef299bbef4b7b61cfc4c90057bb9008abf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c85e9fe040138768ede9839b1cac59f998d272fddf95abfd44c85c216439b224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5286b3c13ade7010f0192aa81d30debd33718ef20fd3fa8c6353506824b1ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "934bad0cb25cbb5a352e23a497d3e14b1267b663cce1d6e6a1ef91cf738a62c0"
    sha256 cellar: :any_skip_relocation, ventura:        "03ec417e06799ea7bfcb9cdb607d0070cfc7e07f79de1cfe7c6ab1fd0052dc48"
    sha256 cellar: :any_skip_relocation, monterey:       "c017f98f0cce7e48f713ac14622d8988f9f35b219bc67a3172f93a222ebfb06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22ed94362daaffe9ce02ba5c67f3ec48165f7a984f0b9550f8cfe2a65c94062"
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