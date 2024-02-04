class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.4.tar.gz"
  sha256 "324dcc99a8c85551f7a8a30416c7fc2e3669c3c3726b75676474c7bfe603cf13"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af97d9d2f5a603e238fb6615ceb15dc171d31eb5e8c8649281fc0a9e412667ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dde91e5bef0ec62b9a3c5d329d6354a7406e5a395ad8073a7ad1c79279982e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe6dd1a4166a1d5ae79e40ea25673b7f11deff02e4b7c31ff31bf799c088340f"
    sha256 cellar: :any_skip_relocation, sonoma:         "508251faaea3b70d79471e751fa2e4be8a5e1a057b00469a67f81aeba97a4411"
    sha256 cellar: :any_skip_relocation, ventura:        "55caacc23740002c44e12738d220d42a28bab1fcbd6360096195617d0d6fadfd"
    sha256 cellar: :any_skip_relocation, monterey:       "486cde63e78db8329ea042207f7ac8b6a22444106a095bccd11d5500a514bc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e179d9d22dfb8cb27fdf7454db3052fb7bb3776f80550fe921766eb9aa42aa3"
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