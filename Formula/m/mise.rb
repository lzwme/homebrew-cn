class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.6.tar.gz"
  sha256 "af03b2b7cad13f772b0373ac0f19c8174e9d3145729db4b37ac4116be33398df"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c0105e2411b3aad91ae8933892a8652b2602256bb06ccc25d910d3c6bae206b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbe3668d270cad765bbe2004180c8eac4a82f8cc70a7f284cdc08f82c46660b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7384d39d125114ffe20b52174651d2922566bab3b964c198caa333b633e37c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6406a5ce355ad930ff2091630d876e8e62f79f8a611ab9cf38f75d0be69b7a12"
    sha256 cellar: :any_skip_relocation, ventura:        "78e8170822210f0b7e7c7c2940735c369288af136debbe419172ffa14c1ef391"
    sha256 cellar: :any_skip_relocation, monterey:       "84fa38dfaafb8c6f518c4e57f511e093aa16905b66274113c3dd6287f627cd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7612cca76eef511e75f47678d7958c35dcebd8b7bade841e5cc59b56db499ce5"
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