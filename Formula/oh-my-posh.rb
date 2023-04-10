class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.29.1.tar.gz"
  sha256 "4c0ea4f6bf82270196131511761b5760fd3daa9ed23fd034d4c3f88d84e90df2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2719f8e05a45385102d962047190241daa95aa0013b2d8faf017cfe1c31ece9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e56acd85d0bc0e4c0afea45538d461e6bebd6f6b1685489ac4e84158c2757b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97f00af68c7eb8eab9f44bd0a5b1107fe5d64016b637b19299e19b299cd043a4"
    sha256 cellar: :any_skip_relocation, ventura:        "3e536905b1b7e3b1f5a4bbb3cb562ea1c6c340b5c70ca3dc3710361c781fd8a2"
    sha256 cellar: :any_skip_relocation, monterey:       "5f7e334d8c5cf9fac4d87464d1515d70e91c042996f1026357ef3f71c360b6e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc055b97c2f82beb4dbb04d49411cad6a7ec894cfdbf8e74cf64457bb173b734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7cabc8739b71b7031f942e1cef3311ed8d496243d5f7d345153435b1b6e99ab"
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