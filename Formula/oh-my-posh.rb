class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.1.0.tar.gz"
  sha256 "c271013855ee373e6bce40a3eb4bc356a14888b3afe06918e2be436eb63ad3aa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a55eff057481b2e28adbc2f8d81ebaaefe77f35c0ea2a14c4a3a2b6dc339d3a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f88bf48f7130866852e0433fe17907db0e0d724923cdff25e2cd1d5d4afc1df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "000cd9902cf8127d6e55e9b1e95e6ae13c8e7b690012c0de651c9ec929027a0b"
    sha256 cellar: :any_skip_relocation, ventura:        "dc3830f2f3151b3cd0a0499e5482fda8af24b26fecb0c587701900297feb1e1f"
    sha256 cellar: :any_skip_relocation, monterey:       "949419ce795c32de387ac4b651741c96675127c4c6b49fbc038e299e81e45400"
    sha256 cellar: :any_skip_relocation, big_sur:        "dad15d5f13420d80f2eeb29e567480c8f3603e53be5c58472752dd6cf5f03ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26d97fb007bd74ea19f9ba681d93f503e448831d8bc3a3d6d379356e327a4ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end