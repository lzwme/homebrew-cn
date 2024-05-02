class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.0.tar.gz"
  sha256 "d2d4abc67232ccff561dd0139b7f3c54d241f51b4fc09715209706397a84e48c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b6ec4d43f34f51b637510f9b0d404f17f0902f008461df6ecf4fc69e1660afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ba4705b8342ee2f08c4dfb26820acefc4111bc88bc7dd1a0c7cd906f7544954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a25f0ce6393d14c20e396d80c49cbf8a1746966003c22a4f58ee19d8221844"
    sha256 cellar: :any_skip_relocation, sonoma:         "80225389b08bef57e4614b261198c6e6e5cec2d5a2cfc2f4892c6f0583584415"
    sha256 cellar: :any_skip_relocation, ventura:        "d455b0ac3efed0019e0d6c7fd72dd3c37711f5449abd57f813f06d9f4385a006"
    sha256 cellar: :any_skip_relocation, monterey:       "7d8b1886cca18210d3ca5b3f5d3f8070e0dc78790cfa799fbf1e37684fd35932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798e6079c88e2567056ef2b8f3e543dcdec54a6e60cd806f02ac90a26ad91b07"
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