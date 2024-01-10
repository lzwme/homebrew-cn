class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.14.tar.gz"
  sha256 "7a568337304d629ea030ebf9f9ac1905300086ef491807e0918c2d0b14229466"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce355261b57418a40d674a8094fd41aae601eb0852293c062a762b1c35dfc779"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6ca957234c51fae75a5d8474b0c55f229508c61daeb0c9687cbc4accea33ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0fa0c5a7b7557e0564056875ce779ca638c4cc19b111e936164b5c0f491d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1c974130d0ef7d64a998a07bdbc05926db89ce64331e7c5f103ff476b511ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "2b4f3180ac98466b3e760f4a87dd8bbfe1a90d1e3ea370ca8fc885323ef8579c"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9d34d70782a1d1ebbdce33b237c73ac01202112ef138e821e57b95bb6847f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcfaed4fa751c7a0334994b71a31340933e2d317c1b118f8466c081acfd7d010"
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