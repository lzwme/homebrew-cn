class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.14.tar.gz"
  sha256 "bef3ca039aa35cf697498b83a8152d7baddca2ad2a79c7b3b4c56226d63735b0"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1ffbb13b7e8bed4766be8828e59962fb3f3e328b22f76699c863c317ffe9480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5f82e9e6016a5dc7e3d912c2ff99efc22522d3df59a5d43c9a6bafcbb8b9db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3144ce68113024a157835d76a2fe53c71d77d37ab9ed60ae7a9cb1fcbe375c"
    sha256 cellar: :any_skip_relocation, sonoma:         "45d33e5201f7f2d38fe43facd89147de81b1bd5ab757cb05aabaaeecf98e4186"
    sha256 cellar: :any_skip_relocation, ventura:        "077a512696ea0a0553e6214dcbe1cf55546809f68544419e32fdcff8a3fedbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "b668648afeee0134ffc7fa12ec047ad7a0de0ac4220d4ce8d148e5133e827fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47460c475819ee2374138f6b27f3a2a7f1abd643563a0d90b262f79b3096026b"
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