class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.24.tar.gz"
  sha256 "0d8562c8883448022c166e59f9805c76231c57c278e8f0c322531913943c0570"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12c8a450554b7ccb736f67b91f1524fe0cc335abd7f4057e676f05917a17a931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91a5c7bf4c3108f7dff4302d35782bd0a316e4f682b5f1e9567faea618b13b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee9ff867aa4b06ff8ef0a39032a3edbe37eeca451f9cd029dd8d619e1b0efd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fea1f917075a396a907bc5e75894ac1d730f1116960d13aacc6ddc140c7ffd9"
    sha256 cellar: :any_skip_relocation, ventura:        "79c0aa6afa62de16bf30af91ce3b4c40c67fac53da3552fa1e2843d2ad5b1324"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d1287b5e30a0746d06eac43f95a9498a1a0935a5db36a75386aa7512fe9b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3486c919d54f4a154aabdf9f02e32b9943ec0ae211c0460b9ee2ca7b6fdeb9e"
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