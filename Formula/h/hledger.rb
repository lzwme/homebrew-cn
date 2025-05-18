class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https:hledger.org"
  url "https:github.comsimonmichaelhledgerarchiverefstags1.42.2.tar.gz"
  sha256 "797cf5dd5d020799b8db0bccc2ba541d5a8c460c2bf3410cfb41b291df3f00c6"
  license "GPL-3.0-or-later"
  head "https:github.comsimonmichaelhledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https:hledger.orginstall.html"
    regex(%r{href=.*?tag(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4404642682528326d920ad9db468c7fc53b4549f18bf587a6aa66a55dbdc2168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5055b0437a8dc25a5ca9d1efd9bf22a8e9897cb3444333cd1ea5c455c5c967c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99056ad91913b439836caf47d66540f6a572dfc94fd9c38255f28c9e4ce0a198"
    sha256 cellar: :any_skip_relocation, sonoma:        "c932b768031f976484c9fe166c9a2d7198dfab724ad76fd0f3f47c2d91bae141"
    sha256 cellar: :any_skip_relocation, ventura:       "240049064e303407cde58a0bcb2f1adccc0c6f9002be151a941b5bdc4be819db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd321dd5811380d2e5408deb4c3c9cbe96e97373b7b864e0640bd216412a805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf679288a32c945579ac6bd733ff589dcbb48478174a6ed39f16e64a2de2f8be"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger**.1"]
    info.install Dir["hledger**.info"]
    bash_completion.install "hledgershell-completionhledger-completion.bash" => "hledger"
  end

  test do
    system bin"hledger", "test"
    system bin"hledger-ui", "--version"
    system bin"hledger-web", "--test"
  end
end