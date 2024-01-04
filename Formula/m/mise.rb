class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.3.tar.gz"
  sha256 "abee10fd882391051390c7720cb71af2e3a1f8496f01701d8ac619d1fefb4da4"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ee8d2ffa8e2c826c840bc73a52df5025ff6b9acb0a7a2f4bd374154aa1812cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c6fd332e2c78979251604c00146c40395b3d478dc2203636b14d1789b2ab632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb8b70150d01abb645055005a407ad182328f88d1b0d8f1a8b89ebd86a8781b"
    sha256 cellar: :any_skip_relocation, sonoma:         "073fdf62223a0ddb8a000b56f21b969da263d378accbcfc866cfa0afb13ba0ec"
    sha256 cellar: :any_skip_relocation, ventura:        "d95f1af33a06e651d590c803666b0ad9e59d06d564e43893ec8a15f27c0db93a"
    sha256 cellar: :any_skip_relocation, monterey:       "92376e47a3681230f76c493067673fc69c2bdbd14c436dfdabf2026f78e059a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3324b4cb57dc37fb5a2cd9c6a753e592962136e95b0ff7c269b3a4bf1f3fabe"
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