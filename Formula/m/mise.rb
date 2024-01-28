class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.30.tar.gz"
  sha256 "2ef217949a5b5dae8fcc2422e6badacd3381225c58bd72fb26d082b15e8b9723"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20f12e9de4ec957fca79bdf88e97261d5bb9b102c3f33600d7996aa74401fdee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a0d94d95c59a110c0c1651586535fd2f125be38f9069d9e34c3c65c303f9d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56703f84442ab2656d7739944aa60c5c3f707042b04520e3080e443fdf035ef3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1937b04603bd47dad31656566455af635e1bd6453eb22835aa9adcfb904e61c8"
    sha256 cellar: :any_skip_relocation, ventura:        "df3916787bd9636f5a9fac6b9a22d1454e10e4cfa034ac7f2d4a84db96d82465"
    sha256 cellar: :any_skip_relocation, monterey:       "11f47ead241261eb54622debc4b4c7293c8981f2ddbb6fef4e125831c9c98e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba784005dd468983d9a9ff1c9573a98dffc5b4e6d6d93391bff4f343b2487505"
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