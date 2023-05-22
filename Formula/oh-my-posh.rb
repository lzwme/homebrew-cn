class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.8.0.tar.gz"
  sha256 "8a96ad2b1a90d35fc15225075185458200818b14fb2005f5e778a937f545ecef"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54009b8e860bb4c42a978221f5c74c93d6b591721cbfb0854f4c1e7bc4ab90aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786c8efdb0994c6caaefbef3e01013ac6eeb2e97d3bcc2aa8496eeb078e984a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd37ea084ed34340e0fdc793d86466eb8ab3beddd412360486e77397a80033c1"
    sha256 cellar: :any_skip_relocation, ventura:        "844515dde8caf2588313706b90c514be3223c6d5ff6f2b65681291dc3d450f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "c9c29b114bd4889e08532b8cdb26953108f765a54628fac85f45a409dffcf4fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ead8849ebefd264de7ff1d3ec69eb770eceedfbe9ee6365c7d376389ca3dfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f08b466ccb7e897ec225cbff287423378188d5d04056f3792d6f9792ab1eda6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end